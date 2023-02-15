require('grumpy.base')
require('grumpy.highlights')
require('grumpy.maps')
require('grumpy.plugins')

local has = vim.fn.has
local is_mac = has "macunix"
local is_win = has "win32"
local is_wsl = has "wsl"

if is_mac then
  require('grumpy.macos')
end
if is_win then
  require('grumpy.windows')
end

if is_wsl then
  require('grumpy.wsl')
end
