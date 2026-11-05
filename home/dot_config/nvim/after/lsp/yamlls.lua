---@type vim.lsp.Config
return {
	settings = {
		yaml = {
			keyOrdering = false,
			-- SchemaStore.nvim supplies the catalog, so yaml-language-server's own fetch stays off.
			schemaStore = { enable = false, url = "" },
			schemas = require("schemastore").yaml.schemas(),
		},
	},
}
