-- Runs Unix programs from an action. On macOS they run directly. On Windows the
-- Rex server is a Windows process and the tools live in WSL, so they run there.

local M = {}

M.windows = package.config:sub(1, 1) == "\\"
M.home = os.getenv("HOME") or os.getenv("USERPROFILE")

-- wsl.exe starts a program without a login shell, so PATH lacks Homebrew. fish -l adds it.
local WSL_LOGIN_SHELL = "/home/linuxbrew/.linuxbrew/bin/fish"

--- C:\Users\me becomes /mnt/c/Users/me.
local function wsl_path(path)
  return (path:gsub("^(%a):", function(drive) return "/mnt/" .. drive:lower() end):gsub("\\", "/"))
end

-- The rex CLI as a shell word. ~/.scripts/rex can come first on PATH and restarts Rex,
-- so name the binary. REX_BIN_DIR is set by Rex on macOS.
M.rex = M.windows
  and '"' .. wsl_path(os.getenv("LOCALAPPDATA") .. "\\Superlogical\\Rex\\rex.com") .. '"'
  or '"${REX_BIN_DIR:+$REX_BIN_DIR/}rex"'

--- Terminal block options that run a program.
--
-- @param argv  The program and its arguments.
-- @param cwd   Unix directory to start in; nil starts in the home directory.
-- @return      Options for rex.layout.block.
function M.options(argv, cwd)
  if not M.windows then
    return { command = argv, cwd = cwd }
  end
  local command = { "wsl.exe", "--cd", cwd or "~", "--exec", WSL_LOGIN_SHELL, "-lc", "exec $argv" }
  for _, arg in ipairs(argv) do
    command[#command + 1] = arg
  end
  return { command = command }
end

return M
