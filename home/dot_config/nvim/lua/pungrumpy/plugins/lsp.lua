require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"tree-sitter-cli",
		-- servers
		"ansible-language-server",
		"biome",
		"copilot-language-server",
		"css-lsp",
		"docker-compose-language-service",
		"dockerfile-language-server",
		"eslint-lsp",
		"gopls",
		"helm-ls",
		"html-lsp",
		"json-lsp",
		"lua-language-server",
		"marksman",
		"oxlint",
		"prisma-language-server",
		"rust-analyzer",
		"tailwindcss-language-server",
		"terraform-ls",
		"tflint",
		"vtsls",
		"yaml-language-server",
		-- linters
		"ansible-lint",
		-- formatters
		"gofumpt",
		"goimports",
		"oxfmt",
		"prettier",
		"prettierd",
		"shfmt",
		"stylua",
	},
	auto_update = false,
	run_on_start = true,
})

vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities({
		workspace = {
			fileOperations = {
				didRename = true,
				willRename = true,
			},
		},
	}),
})

vim.lsp.enable({
	"ansiblels",
	"biome",
	"cssls",
	"docker_compose_language_service",
	"dockerls",
	"eslint",
	"gopls",
	"helm_ls",
	"html",
	"jsonls",
	"lua_ls",
	"marksman",
	"oxlint",
	"prismals",
	"rust_analyzer",
	"tailwindcss",
	"terraformls",
	"tflint",
	"vtsls",
	"yamlls",
})
