---@type vim.lsp.Config
return {
	settings = {
		yaml = {
			keyOrdering = false,
			-- SchemaStore.nvim supplies the catalog, so yaml-language-server's own fetch stays off.
			schemaStore = { enable = false, url = "" },
			schemas = require("schemastore").yaml.schemas({
				extra = {
					{
						name = "Kubernetes",
						description = "Kubernetes manifests",
						fileMatch = {
							"k8s/**/*.yaml",
							"k8s/**/*.yml",
							"kubernetes/**/*.yaml",
							"kubernetes/**/*.yml",
							"manifests/**/*.yaml",
							"manifests/**/*.yml",
							"*.k8s.yaml",
						},
						url = "kubernetes",
					},
				},
			}),
		},
	},
}
