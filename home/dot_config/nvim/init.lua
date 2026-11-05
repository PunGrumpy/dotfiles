if vim.loader then
	vim.loader.enable()
end

require("pungrumpy.config.options")
require("pungrumpy.config.keymaps")
require("pungrumpy.config.autocmds")
require("pungrumpy.config.commands")
require("pungrumpy.plugins")
