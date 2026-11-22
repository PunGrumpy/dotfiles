-- Theme, font and padding live in Rex Settings. .scripts/rex sets them.
-- Each file beside this one holds one concern. Add new ones here.

require("keybindings")

-- Ports of the tmux popups: lazygit in a floating layer, Claude Code in its own tab, both in the focused pane's directory.
local terminal = "com.superlogical.terminal"

-- pwd comes back as file://<host>/path, percent-encoded.
local function focused_pwd()
  local r = rex.block.call(terminal, "pwd", {})
  local p = r and r.pwd or ""
  p = p:gsub("^file://[^/]*", ""):gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end)
  if p == "" then return os.getenv("HOME") end
  return p
end

local function program(command, label, cwd)
  return rex.layout.block{
    flavor = terminal .. ".shell",
    label = label,
    options = { command = command, cwd = cwd },
  }
end

rex.action{
  name  = "lazygit",
  title = "Open lazygit here",
  run   = function(ctx, args)
    local _, err = rex.session.new_layer{
      bounds = { 0.1, 0.1, 0.8, 0.8 },
      focus = true,
      layout = program({ "lazygit" }, "lazygit", focused_pwd()),
    }
    if err ~= nil then error(err, 0) end
  end,
}

rex.action{
  name  = "claude_here",
  title = "Open Claude Code here",
  run   = function(ctx, args)
    local w, err = rex.session.new_window{
      focus = true,
      layout = program({ "claude" }, "claude", focused_pwd()),
    }
    if err ~= nil then error(err, 0) end
    return { window_id = w.window_id }
  end,
}

rex.bind("ctrl+a>l", "lazygit")
rex.bind("ctrl+a>a", "claude_here")

-- sshpick: pick a host in a floating layer, open it in a labelled tab. See sshpick's docs/rex.md.
-- It lives in its own repo and is linked in by hand, so a machine without it still loads this file.
local ok, err = pcall(require, "sshpick")
if ok then
  rex.bind("ctrl+a>s", "sshpick")
elseif not tostring(err):find("module sshpick not found", 1, true) then
  error(err, 0)
end
