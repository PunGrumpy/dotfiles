require('grumpy.base')
require('grumpy.highlights')
require('grumpy.maps')
require('grumpy.plugins')

local os = vim.loop.os_uname().sysname

if os == "Darwin" then
  require('grumpy.macos')
elseif os == "Linux" then
  require('grumpy.linux')
elseif os == "Windows" then
  require('grumpy.windows')
else
  error("Unsupported OS: " .. os)
end
