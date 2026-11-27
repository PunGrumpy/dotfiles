-- Rex on Windows reads %AppData%\rex\init.lua. The config lives in ~/.config/rex, as on macOS.
local dir = os.getenv("USERPROFILE") .. "\\.config\\rex"
package.path = dir .. "\\?.lua;" .. package.path
dofile(dir .. "\\init.lua")
