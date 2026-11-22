-- The working directory of a pane.

local M = {}

--- Reads the cwd of the program running in a pane, so a popup opens where the pane is.
-- Unlike the pwd call, this does not depend on the shell reporting OSC 7.
--
-- @param block_id  ID of the pane, usually ctx.block_id.
-- @return          Absolute path, or the home directory when the pane reports none.
function M.of(block_id)
  local process = rex.block.call("com.superlogical.terminal", "process", { block_id = block_id })
  local running = process and (process.foreground or process.child)
  return running and running.cwd or os.getenv("HOME")
end

return M
