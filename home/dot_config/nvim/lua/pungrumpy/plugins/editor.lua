---@module 'blink.cmp'
---@type blink.cmp.Config
require("blink.cmp").setup({
	snippets = { preset = "default" },
	completion = {
		accept = { auto_brackets = { enabled = true } },
		menu = {
			border = "none",
			winblend = vim.o.pumblend,
			draw = { treesitter = { "lsp" } },
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},
	signature = {
		window = { winblend = vim.o.pumblend },
	},
	cmdline = {
		enabled = true,
		keymap = {
			preset = "cmdline",
			["<Right>"] = false,
			["<Left>"] = false,
		},
		completion = {
			list = { selection = { preselect = false } },
			menu = {
				auto_show = function()
					return vim.fn.getcmdtype() == ":"
				end,
			},
			ghost_text = { enabled = true },
		},
	},
	keymap = { preset = "enter" },
})

require("mini.pairs").setup({
	modes = { insert = true, command = true, terminal = false },
})

require("mini.diff").setup({
	view = {
		-- the whole reference part above the whole buffer part, as in `git diff`
		overlay_style = "hunk",
	},
	mappings = {
		-- same keys as codediff.nvim
		goto_next = "]c",
		goto_prev = "[c",
	},
})

require("todo-comments").setup()
require("gitsigns").setup()
require("gitlinker").setup()

local prettier = { "oxfmt", "prettierd", "prettier", stop_after_first = true }
require("conform").setup({
	default_format_opts = {
		timeout_ms = 3000,
		async = false,
		quiet = false,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		javascript = prettier,
		javascriptreact = prettier,
		typescript = prettier,
		typescriptreact = prettier,
		json = prettier,
		jsonc = prettier,
		css = prettier,
		scss = prettier,
		less = prettier,
		html = prettier,
		yaml = prettier,
		markdown = prettier,
		mdx = prettier,
		go = { "goimports", "gofumpt" },
		lua = { "stylua" },
		sh = { "shfmt" },
		fish = { "fish_indent" },
	},
	formatters = {
		-- Run only in projects that have a config for the tool, falling back to the next one.
		oxfmt = { require_cwd = true },
		prettierd = { require_cwd = true },
		prettier = { require_cwd = true },
	},
	format_on_save = function(bufnr)
		if vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 500 }
	end,
})

-- Colors come from nvim-highlight-colors, not from LSP document colors.
vim.lsp.document_color.enable(false)
require("nvim-highlight-colors").setup({
	render = "background",
	enable_hex = true,
	enable_short_hex = true,
	enable_rgb = true,
	enable_hsl = true,
	enable_hsl_without_function = true,
	enable_ansi = true,
	enable_var_usage = true,
	enable_tailwind = true,
})
