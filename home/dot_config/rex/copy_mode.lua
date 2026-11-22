-- Copy mode on ctrl+a>[ : the pane's scrollback opens read-only in nvim in a floating pane.
-- Visual select + enter copies to the clipboard and closes. q closes.
-- A full-screen program shows only its visible rows, because the alternate
-- screen keeps no scrollback.
-- The mappings are buffer-local so they win over global ones from plugins.
-- A stdin buffer is listed with an empty buftype, so Copilot would attach and
-- upload the scrollback. StdinReadPre makes it a nofile buffer before the read.

local floating_pane = require("floating_pane")

local SCROLLBACK_IN_NVIM = [[
rex capture -s "$1" -b "$2" --trim | nvim -R \
  --cmd 'autocmd StdinReadPre * setlocal buftype=nofile nobuflisted' \
  -c 'xnoremap <buffer> <CR> "+y<Cmd>qa!<CR>' \
  -c 'xnoremap <buffer> q <Cmd>qa!<CR>' \
  -c 'nnoremap <buffer> q <Cmd>qa!<CR>' \
  -c 'normal! G' -
]]

rex.action{
  name  = "copy_mode",
  title = "Copy Mode (Scrollback in nvim)",
  run   = function(ctx, args)
    local layer = floating_pane.run(ctx, SCROLLBACK_IN_NVIM)
    return { block_ids = layer.block_ids }
  end,
}

rex.bind("ctrl+a>[", "copy_mode")
