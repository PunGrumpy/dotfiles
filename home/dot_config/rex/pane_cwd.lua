-- The working directory of a pane.

local unix = require("unix")

local M = {}

--- Reads the cwd of the program running in a pane, so a popup opens where the pane is.
-- On macOS this reads the process, so it does not depend on the shell reporting OSC 7.
-- On Windows the process is wsl.exe, so it reads the OSC 7 path that fish reports.
--
-- @param block_id  ID of the pane, usually ctx.block_id.
-- @return          Absolute Unix path, or nil on Windows when the pane reports none.
function M.of(block_id)
  if unix.windows then
    local reported = rex.block.call("com.superlogical.terminal", "pwd", { block_id = block_id })
    local path = reported and reported.pwd and reported.pwd:match("^file://[^/]*(/.*)$")
    return path and (path:gsub("%%(%x%x)", function(hex) return string.char(tonumber(hex, 16)) end))
  end
  local process = rex.block.call("com.superlogical.terminal", "process", { block_id = block_id })
  local running = process and (process.foreground or process.child)
  return running and running.cwd or unix.home
end

return M
