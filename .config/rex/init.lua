-- Theme, font and padding live in Rex Settings. .scripts/rex sets them.

-- Font size
rex.bind("ctrl+=", "client.font.increase")
rex.bind("ctrl+shift+=", "client.font.increase")
rex.bind("ctrl+-", "client.font.decrease")
rex.bind("ctrl+0", "client.font.reset")
rex.bind("ctrl+shift+b", "client.font.reset")

-- tmux-like leader bindings on ctrl+a
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })
rex.bind("ctrl+a>ctrl+r", "client.config.reload")
rex.bind("ctrl+a>c", "client.tab.new")
rex.bind("ctrl+a>ctrl+c", "client.tab.new")
rex.bind("ctrl+a>n", "client.tab.next")
rex.bind("ctrl+a>ctrl+n", "client.tab.next")
rex.bind("ctrl+a>p", "client.tab.previous")
rex.bind("ctrl+a>ctrl+p", "client.tab.previous")
rex.bind("ctrl+a>q", "client.tab.close")
rex.bind("ctrl+a>ctrl+q", "client.tab.close")
rex.bind("ctrl+a>r", "client.tab.rename")
rex.bind("ctrl+a>h", "pane.split", { direction = "right" })
rex.bind("ctrl+a>ctrl+h", "pane.split", { direction = "right" })
rex.bind("ctrl+a>v", "pane.split", { direction = "down" })
rex.bind("ctrl+a>ctrl+v", "pane.split", { direction = "down" })
rex.bind("ctrl+a>e", "pane.balance")
rex.bind("ctrl+a>ctrl+e", "pane.balance")

-- Large split jumps work best from a balanced layout.
rex.bind("ctrl+a>shift+y", "pane.resize", { direction = "left", amount = 60 })
rex.bind("ctrl+a>shift+u", "pane.resize", { direction = "right", amount = 60 })
rex.bind("ctrl+a>shift+g", "pane.resize", { direction = "up", amount = 36 })
rex.bind("ctrl+a>shift+t", "pane.resize", { direction = "down", amount = 36 })

rex.bind("ctrl+a>y", "pane.resize", { direction = "left", amount = 10 })
rex.bind("ctrl+a>ctrl+y", "pane.resize", { direction = "left", amount = 10 })
rex.bind("ctrl+a>u", "pane.resize", { direction = "right", amount = 10 })
rex.bind("ctrl+a>ctrl+u", "pane.resize", { direction = "right", amount = 10 })
rex.bind("ctrl+a>g", "pane.resize", { direction = "up", amount = 10 })
rex.bind("ctrl+a>ctrl+g", "pane.resize", { direction = "up", amount = 10 })
rex.bind("ctrl+a>t", "pane.resize", { direction = "down", amount = 10 })
rex.bind("ctrl+a>ctrl+t", "pane.resize", { direction = "down", amount = 10 })
rex.bind("ctrl+a>z", "pane.zoom")
rex.bind("ctrl+a>ctrl+z", "pane.zoom")
rex.bind("ctrl+a>left", "client.tab.move.backward")
rex.bind("ctrl+a>ctrl+left", "client.tab.move.backward")
rex.bind("ctrl+a>right", "client.tab.move.forward")
rex.bind("ctrl+a>ctrl+right", "client.tab.move.forward")

-- Pane navigation mirrors the prefix-less tmux binds.
rex.bind("ctrl+l", "pane.focus", { direction = "left" })
rex.bind("ctrl+;", "pane.focus", { direction = "right" })
rex.bind("ctrl+k", "pane.focus", { direction = "up" })
rex.bind("ctrl+j", "pane.focus", { direction = "down" })

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
