---@type vim.lsp.Config
return {
	settings = {
		["rust-analyzer"] = {
			cargo = { allFeatures = true },
			check = { command = "clippy" },
			procMacro = { enable = true },
		},
	},
}
