-- Floating panes that run one script and hand focus back when it exits.

local M = {}

local SHELL_FLAVOR = "com.superlogical.terminal.shell"
local BOUNDS = { 0.1, 0.1, 0.8, 0.8 }

-- Rex picks another pane when a floating pane closes, so the script refocuses
-- the pane it was opened from. rex is a function because the first rex on PATH
-- can be ~/.scripts/rex, which restarts Rex. REX_BIN_DIR is set by Rex.
local PRELUDE = 'rex() { "${REX_BIN_DIR:+$REX_BIN_DIR/}rex" "$@"; }\n'
local REFOCUS_ORIGIN = '\nrex focus -s "$1" "$2"\n'

--- Runs a shell script in a floating pane over the window.
--
-- Inside the script, "$1" is the session ID and "$2" the ID of the pane the
-- action was run from. Focus returns to that pane when the script ends.
--
-- @param ctx     The action's ctx table (session_id, block_id).
-- @param script  POSIX shell script to run.
-- @param cwd     Directory to start in; nil starts in the home directory.
-- @return        The new layer's result table (layer_id, block_ids).
function M.run(ctx, script, cwd)
  local layer, err = rex.session.new_layer{
    bounds = BOUNDS,
    focus  = true,
    layout = rex.layout.block{
      flavor  = SHELL_FLAVOR,
      options = {
        command = { "sh", "-c", PRELUDE .. script .. REFOCUS_ORIGIN, "floating_pane", ctx.session_id, ctx.block_id },
        cwd     = cwd,
      },
    },
  }
  if err ~= nil then error(err, 0) end
  return layer
end

return M
