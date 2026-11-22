-- Claude Code in its own tab, opened in the focused pane's directory.

local pane_cwd = require("pane_cwd")

rex.action{
  name  = "claude_here",
  title = "Open Claude Code here",
  run   = function(ctx, args)
    local w, err = rex.session.new_window{
      focus = true,
      layout = rex.layout.block{
        flavor = "com.superlogical.terminal.shell",
        label = "claude",
        options = { command = { "claude" }, cwd = pane_cwd.of(ctx.block_id) },
      },
    }
    if err ~= nil then error(err, 0) end
    return { window_id = w.window_id }
  end,
}

rex.bind("ctrl+a>a", "claude_here")
