-- Which panes run ssh, where to, and whether that ssh is safe to run again.

local M = {}

local TERMINAL = "com.superlogical.terminal"

-- ssh's short options. `value` is true for one that takes a value. `rerun` is
-- false for one that makes a second ssh wrong: no remote shell (-N, -s, -T),
-- no session at all (-O, -Q, -V, -G, -W), a background ssh (-f, -n), or state
-- the first ssh owns (-M, -S, -w).
local OPTIONS = {}
local function declare(letters, option)
  for letter in letters:gmatch(".") do OPTIONS[letter] = option end
end
declare("46AaCgKkqtvXxYy",   { value = false, rerun = true })
declare("fGMNnsTV",          { value = false, rerun = false })
declare("BbcDEeFIiJLlmoPpR", { value = true,  rerun = true })
declare("OQSWw",             { value = true,  rerun = false })

-- The -o spellings of the options above, and the two that carry a command.
local REFUSED_SETTINGS = {
  controlmaster = true, controlpath = true, forkafterauthentication = true,
  localcommand = true, remotecommand = true, requesttty = true,
  sessiontype = true, stdinnull = true, tunnel = true, tunneldevice = true,
}

-- Programs that start ssh and then only wait for it.
local WRAPPERS = { sh = true, bash = true, dash = true, ksh = true, zsh = true, fish = true, login = true }

local function program_of(command)
  return (command:match("^%-?(%S*)"):match("[^/]*$"))
end

-- A value that itself holds spaces cannot be told apart from the words after it.
local function setting_is_safe(value)
  local name = value:match("^(%a+)=.")
  return name ~= nil and not REFUSED_SETTINGS[name:lower()]
end

local function host_of(destination)
  local rest, is_url = destination:gsub("^ssh://", "")
  if is_url == 1 then rest = rest:gsub("/.*$", ""):gsub(":%d+$", "") end
  return (rest:gsub("^.*@", ""):gsub("^%[(.*)%]$", "%1"))
end

--- Reads an ssh command line as ps prints it, with its quoting lost.
--
-- argv is nil unless a second run is known to open the same login and nothing
-- else. A remote command is never run again.
--
-- @param command  ssh's arguments joined by spaces, "ssh" first.
-- @return         { host, argv }; host is nil when the options hide it.
function M.parse(command)
  local words = {}
  for word in command:gmatch("%S+") do words[#words + 1] = word end

  -- A double space is an empty argument, and a backslash may be ps's own escape.
  local rerun = not command:find("  ", 1, true) and not command:find("\\", 1, true)
  local host
  local options_ended = false
  local i = 2
  while i <= #words do
    local word = words[i]
    if options_ended or not word:match("^%-.") then
      if host ~= nil then return { host = host } end
      host = host_of(word)
    elseif word == "--" then
      options_ended = true
    else
      local at = 2
      while at <= #word do
        local letter = word:sub(at, at)
        local option = OPTIONS[letter]
        if option == nil then return { host = host } end
        rerun = rerun and option.rerun
        if option.value then
          local value = word:sub(at + 1)
          if value == "" then
            i = i + 1
            value = words[i]
          end
          if value == nil or (letter == "o" and not setting_is_safe(value)) then rerun = false end
          break
        end
        at = at + 1
      end
    end
    i = i + 1
  end
  if host == nil or not rerun then return { host = host } end

  -- The first pane already holds the forwarded ports. ssh keeps the first value
  -- of an option, so this one wins.
  local argv = { words[1], "-o", "ClearAllForwardings=yes" }
  local from = words[2] == argv[2] and words[3] == argv[3] and 4 or 2
  for word = from, #words do argv[#argv + 1] = words[word] end
  return { host = host, argv = argv }
end

--- Finds the ssh that holds the keyboard in a pane.
--
-- ssh may be the foreground process or a child of a shell that waits for it, so
-- the whole process group is read. A group with any other program in it (an
-- editor, an agent or git that runs ssh) is not an ssh pane. What ssh starts
-- itself, such as ProxyJump's `ssh -W`, does not count.
--
-- @param processes  Output of `ps -axww -o pid=,ppid=,pgid=,args=`.
-- @param pid        The pane's foreground process.
-- @return           nil, or what M.parse returns.
function M.find(processes, pid)
  local by_pid = {}
  for line in processes:gmatch("[^\n]+") do
    local id, parent, group, command = line:match("^%s*(%d+)%s+(%d+)%s+(%d+)%s+(.*)$")
    if id ~= nil then
      by_pid[tonumber(id)] = { parent = tonumber(parent), group = tonumber(group), command = command }
    end
  end
  local foreground = by_pid[pid]
  if foreground == nil then return nil end

  local function started_by_ssh(process)
    local parent = by_pid[process.parent]
    while parent ~= nil and parent.group == foreground.group do
      if program_of(parent.command) == "ssh" then return true end
      parent = by_pid[parent.parent]
    end
    return false
  end

  local found = {}
  for _, process in pairs(by_pid) do
    if process.group == foreground.group and not started_by_ssh(process) then
      local program = program_of(process.command)
      if program == "ssh" then
        found[#found + 1] = process.command
      elseif not WRAPPERS[program] then
        return nil
      end
    end
  end
  if #found == 0 then return nil end
  -- `ssh a | ssh b` has no one host to name and no one command to run again.
  if #found > 1 then return {} end
  return M.parse(found[1])
end

--- Reads what a pane runs.
--
-- @param block_id  ID of the pane, usually ctx.block_id.
-- @return          nil when the pane is not ssh, else { argv, cwd, host }. argv
--                  is nil when ssh must not be run again.
-- @return          The pane's foreground process as Rex describes it. nil when
--                  it cannot be read, and then nothing is known about the pane.
function M.of(block_id)
  local process = rex.block.call(TERMINAL, "process", { block_id = block_id })
  local running = process and process.foreground
  if running == nil then return nil, nil end
  -- Rex hides arguments because they can hold secrets, so ps is asked.
  local ps, err = rex.exec({ "/bin/ps", "-axww", "-o", "pid=,ppid=,pgid=,args=" }, { timeout = 5 })
  if ps == nil or not ps.ok then
    rex.log("warn", "ssh_pane: ps failed: " .. (err or ps.stderr))
    return nil, nil
  end
  local ssh = M.find(ps.stdout, running.pid)
  if ssh ~= nil then ssh.cwd = running.cwd end
  return ssh, running
end

return M
