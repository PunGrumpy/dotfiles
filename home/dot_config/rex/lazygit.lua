-- lazygit in a floating pane on ctrl+a>l, opened in the focused pane's directory.

local floating_pane = require("floating_pane")
local pane_cwd = require("pane_cwd")

rex.action{
  name  = "lazygit",
  title = "Open lazygit here",
  run   = function(ctx, args)
    floating_pane.run(ctx, "lazygit", pane_cwd.of(ctx.block_id))
  end,
}

rex.bind("ctrl+a>l", "lazygit")
