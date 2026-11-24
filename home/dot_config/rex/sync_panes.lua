-- Live sync on ctrl+a>i, like broadcast input in iTerm2: type in any pane and the
-- key goes to every matching pane of the tab. ctrl+a>i again stops it.
--
-- From an ssh pane, only ssh panes match. From any other pane, only panes that
-- run the same program and are not ssh, so keys meant for remote hosts never
-- reach a local shell, editor or agent.
--
-- While sync is on, every key is bound to a function that copies it to the other
-- panes and lets Rex type it in this one. A key mode would do the same, but Rex
-- lists all of a mode's keys over the panes. The keys are bound only while sync
-- is on: turning it on or off writes STATE and reloads this configuration.
--
-- Each synced pane reports OSC 7501, as an agent does, so Rex marks its tab,
-- and the edges of the focused pane turn blue, the focus color of Geist. Rex has one such color for the
-- whole app, so it goes back when the last sync ends.

local ssh_pane = require("ssh_pane")
local sync_keys = require("sync_keys")

local TERMINAL = "com.superlogical.terminal"
local STATE = (os.getenv("TMPDIR") or os.getenv("HOME") .. "/Library/Caches"):gsub("/$", "") .. "/rex-sync.json"

-- Window ID to { session_id, is_ssh, targets, border }.
local groups = {}
do
  local file = io.open(STATE)
  if file then
    local ok, saved = pcall(rex.json.decode, file:read("*a"))
    file:close()
    if ok and type(saved) == "table" then groups = saved end
  end
end

-- Keys stay bound until the reload after the last sync.
local armed = next(groups) ~= nil
local last_border = armed and select(2, next(groups)).border or nil

local function save()
  if next(groups) == nil then
    os.remove(STATE)
    return
  end
  local file, err = io.open(STATE, "w")
  if file == nil then error(err, 0) end
  file:write(rex.json.encode(groups))
  file:close()
end

--- Reads what a pane is, for comparing panes and naming them.
--
-- @return  { kind, name, pid }, or nil when it cannot be told. Panes with the
--          same kind are typed in together.
local function identify(block_id)
  local ssh, running = ssh_pane.of(block_id)
  if running == nil then return nil end
  if ssh ~= nil then return { kind = "ssh", name = ssh.host or "unknown host", pid = running.pid } end
  -- An ssh that ssh_pane refuses, such as git's, is neither a login nor a local program.
  if running.name == "ssh" then return nil end
  -- node is the name of every node program, so its script tells them apart.
  local program = running.script or running.name
  return { kind = "program " .. program, name = program:match("[^/]*$"), pid = running.pid }
end

-- The tab that holds a pane, and its tiled panes by ID.
local function read_tab(ctx)
  local view, err = rex.session.view{}
  if err ~= nil then error(err, 0) end
  for _, window in ipairs(view.windows or {}) do
    for _, layer in ipairs(window.layers) do
      if layer.kind == "tiled" then
        local tab = { window_id = window.window_id, blocks = layer.blocks or {}, here = {} }
        for _, block in ipairs(tab.blocks) do tab.here[block.block_id] = true end
        if tab.here[ctx.block_id] then return tab end
      end
    end
  end
  error("sync works in tiled panes only", 0)
end

local function find_targets(ctx, blocks)
  local origin = identify(ctx.block_id)
  if origin == nil then error("cannot tell what this pane runs", 0) end

  local targets, is_ssh = {}, origin.kind == "ssh"
  for _, block in ipairs(blocks) do
    if block.creator_name == TERMINAL then
      local pane = identify(block.block_id)
      if pane ~= nil and pane.kind == origin.kind then
        pane.block_id = block.block_id
        targets[#targets + 1] = pane
      end
    end
  end
  if #targets < 2 then
    local what = is_ssh and "ssh" or ("local " .. origin.name)
    error(("sync needs at least 2 %s panes, and this tab has %d"):format(what, #targets), 0)
  end
  return targets, is_ssh
end

-- Marks panes as synced through their ttys, as if their programs had: a status, as
-- an agent reports it. No message clears it. The fields are all ours. A pane whose program reports its own status gets ours beside it.
local function report(panes, message, delay)
  local script = [[
sleep "$1"; message="$2"; state="$3"
shift 3
while [ $# -gt 1 ]; do
  tty="$1"; id="$2"; shift 2
  if [ -n "$message" ]; then
    # A late report must not mark a pane that left meanwhile.
    grep -q "\"$tty\"" "$state" || continue
    printf '\033]7501;state=working:app=sync:title=U3luYw==:msg=%s%s\033\\' \
      "$(printf %s "$message" | base64)" "$id" > "/dev/$tty"
  else
    printf '\033]7501;state=clear%s\033\\' "$id" > "/dev/$tty"
  fi
done
]]
  local argv = { "/bin/sh", "-c", "(" .. script .. ") >/dev/null 2>&1 &", "sync", tostring(delay or 0), message or "", STATE }
  for _, pane in ipairs(panes) do
    if pane.tty then
      argv[#argv + 1] = pane.tty
      argv[#argv + 1] = pane.root and "" or ":id=sync"
    end
  end
  rex.exec(argv, { timeout = 5 })
end

local function prepare(panes)
  for _, pane in ipairs(panes) do
    local ps = rex.exec({ "/bin/ps", "-o", "tty=", "-p", tostring(pane.pid) }, { timeout = 5 })
    pane.tty = ps and ps.ok and ps.stdout:match("^%s*(ttys%d+)%s*$") or nil
    local status = rex.block.call(TERMINAL, "program_status", { block_id = pane.block_id })
    pane.root = status ~= nil and #(status.records or {}) == 0
  end
end

local function show(group, skipped, delay)
  local total = #group.targets
  local count = skipped > 0 and ("%d of %d"):format(total - skipped, total) or tostring(total)
  report(group.targets, ("Sync typing in %s panes"):format(count), delay)
end

-- An ssh that ended, reconnected or was suspended leaves something else in front,
-- and keys meant for a remote host must not reach it.
local function still_runs(group, pane)
  if not group.is_ssh then return true end
  local process = rex.block.call(TERMINAL, "process", { block_id = pane.block_id })
  return process ~= nil and process.foreground ~= nil and process.foreground.pid == pane.pid
end

-- nil when the screen cannot be read, and then nothing is copied.
local function asks_for_password(block_id)
  local screen = rex.block.call(TERMINAL, "format", { block_id = block_id, trim = true, max_bytes = 262144 })
  if screen == nil or screen.content == nil then return nil end
  local text = screen.content
  -- The text holds the whole scrollback, and a pattern that backtracks over it is slow.
  local line = ""
  for candidate in text:sub(-2000):gmatch("[^\n]+") do
    if candidate:find("%S") then line = candidate end
  end
  return line:lower():find("pass%w*[^:]*:%s*$") ~= nil
end

local function stop(window_id, here)
  local shown = {}
  for _, pane in ipairs(groups[window_id].targets) do
    if here[pane.block_id] then shown[#shown + 1] = pane end
  end
  groups[window_id] = nil
  save()
  -- A late report that checked the state just before may still be writing.
  report(shown, nil, 0.3)
end

local function group_of(block_id)
  for window_id, group in pairs(groups) do
    for _, pane in ipairs(group.targets) do
      if pane.block_id == block_id then return group, window_id end
    end
  end
end

-- Sends an event to the panes synced with this one. Rex types it in this one.
local function copy(ctx, event)
  local group, window_id = group_of(ctx.block_id)
  if group == nil then return end
  local tab = read_tab(ctx)
  local asks = asks_for_password(ctx.block_id)
  local kept, skipped, lost = {}, 0, {}
  for _, pane in ipairs(group.targets) do
    if not tab.here[pane.block_id] or not still_runs(group, pane) then
      lost[#lost + 1] = pane
    else
      kept[#kept + 1] = pane
    end
  end
  if #lost > 0 then
    if #kept < 2 then
      stop(window_id, tab.here)
      return
    end
    local closed = {}
    for _, pane in ipairs(lost) do
      if tab.here[pane.block_id] then closed[#closed + 1] = pane end
    end
    group.targets = kept
    save()
    report(closed, nil, 0.3)
    -- This pane may be the one that left.
    if group_of(ctx.block_id) == nil then return end
  end
  for _, pane in ipairs(kept) do
    if pane.block_id ~= ctx.block_id then
      -- A password goes only where it is asked for, and text never into a password prompt.
      if asks ~= nil and asks_for_password(pane.block_id) == asks then
        rex.call("block.event", { session_id = ctx.session_id, block_id = pane.block_id, event = event })
      else
        skipped = skipped + 1
      end
    end
  end

  -- A new shell prompt drops the status, so it is reported again after Enter.
  local enter = event.type == "key" and event.payload.key == "enter"
  if enter or group.entered or #lost > 0 or skipped ~= (group.skipped or 0) then
    show(group, skipped, enter and 1 or 0)
  end
  group.entered, group.skipped = enter, skipped
end

local function type_key(ctx, ev)
  -- An error here would keep the key from the pane being typed in.
  local ok, err = pcall(copy, ctx, { type = "key", payload = ev.payload })
  if not ok then rex.log("warn", "sync_panes: " .. tostring(err)) end
  return false
end

local BORDER = "client.setting.interface.active_panes.active_border"
local COLORS = { accent = true, red = true, blue = true, green = true, yellow = true, cyan = true, magenta = true, text = true }

-- The user's own highlight. Rex stores only settings that were changed, and the
-- defaults are taken to be off and accent.
local function read_border()
  local function read(key)
    local result = rex.exec({ "/usr/bin/defaults", "read", "com.superlogical.rex", "Workspace." .. key }, { timeout = 5 })
    return result ~= nil and result.ok and result.stdout:match("^%s*(.-)%s*$") or nil
  end
  local color = read("activePaneBorderColor")
  return {
    on      = read("showsActivePaneBorder") == "1",
    color   = COLORS[color] and color or "accent",
    opacity = tonumber(read("activePaneBorderOpacity")),
  }
end

-- The theme's blue, undimmed. Rex moves a number out of range to the nearest end.
local SYNC_BORDER = { on = true, color = "blue", opacity = 1000 }

local function queue_border(border)
  rex.client.queue(BORDER .. "_color", { value = border.color })
  rex.client.queue(BORDER .. "_opacity", border.opacity and { value = border.opacity } or { reset = true })
  rex.client.queue(BORDER, { value = border.on })
end

rex.action{
  name  = "sync_paste",
  title = "Paste in Synced Panes",
  run   = function(ctx, args)
    if group_of(ctx.block_id) ~= nil then
      local clipboard = rex.exec({ "/usr/bin/pbpaste" }, { timeout = 5 })
      if clipboard ~= nil and clipboard.ok and clipboard.stdout ~= "" then
        local ok, err = pcall(copy, ctx, { type = "paste", payload = { text = clipboard.stdout } })
        if not ok then rex.log("warn", "sync_panes: " .. tostring(err)) end
      end
    end
    rex.client.queue("pane.paste")
  end,
}

rex.action{
  name        = "sync_panes",
  title       = "Sync Typing in Matching Panes",
  description = "Type in every pane of this tab that matches this one: ssh panes from an ssh pane, else panes running the same program. Run it again to stop.",
  category    = "SSH",
  keywords    = "ssh send broadcast input synchronize sync type panes",
  run         = function(ctx, args)
    if ctx.server ~= nil then error("sync_panes works only on this machine's panes", 0) end
    local tab = read_tab(ctx)
    local panes, border = 0, nil
    local _, any = next(groups)
    local before = any and any.border
    if groups[tab.window_id] ~= nil then
      stop(tab.window_id, tab.here)
      if next(groups) == nil then border = before end
    elseif armed and any == nil then
      -- The last sync ended by itself, and a key cannot set the highlight back.
      border = last_border
    else
      local targets, is_ssh = find_targets(ctx, tab.blocks)
      prepare(targets)
      -- Groups of tabs that are gone.
      for window_id, group in pairs(groups) do
        local view = rex.call("session.view", { session_id = group.session_id })
        local alive = false
        for _, window in ipairs(view and view.windows or {}) do alive = alive or window.window_id == window_id end
        if not alive then groups[window_id] = nil end
      end
      before = before or read_border()
      groups[tab.window_id] = { session_id = ctx.session_id, is_ssh = is_ssh, targets = targets, border = before }
      save()
      show(groups[tab.window_id], 0)
      panes, border = #targets, SYNC_BORDER
    end
    -- Reload last: it replaces the state that this run still reads.
    if border then queue_border(border) end
    rex.client.queue("client.config.reload")
    return { panes = panes }
  end,
}

rex.bind("ctrl+a>i", "sync_panes")
if next(groups) ~= nil then
  local taken = {}
  for _, binding in ipairs(rex.bindings()) do taken[binding.key:match("^[^>]+")] = true end
  sync_keys.each(taken, function(key) rex.bind(key, type_key) end)
  rex.bind("cmd+v", "sync_paste")
end
