local lazygit = require("pungrumpy.utils.lazygit")

require("vercel").setup({ style = "dark" })
vim.cmd.colorscheme("vercel-dark")

require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()

require("pungrumpy.utils.tabline").setup()

local lazygit_config = {}
if vim.fn.has("win32") == 0 then
	lazygit_config.os = {
		edit = lazygit.edit_command(),
		editAtLine = lazygit.edit_command(true),
	}
end

require("snacks").setup({
	indent = { enabled = true },
	scroll = { enabled = false },
	picker = {
		enabled = true,
		sources = {
			files = { hidden = true },
			grep = { hidden = true },
		},
	},
	notifier = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	lazygit = {
		enabled = true,
		config = lazygit_config,
	},
})

require("tiny-cmdline").setup({
	position = { y = "20%" },
})

local function macro_recording()
	return "󰑋 " .. vim.fn.reg_recording()
end

require("lualine").setup({
	options = {
		theme = "vercel",
		globalstatus = true,
		disabled_filetypes = { statusline = { "snacks_dashboard" } },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{ "filename", path = 1, symbols = { modified = "[+]", readonly = "󰌾", unnamed = "" } },
		},
		lualine_x = {
			{
				macro_recording,
				cond = function()
					return vim.fn.reg_recording() ~= ""
				end,
				color = "DiagnosticError",
			},
			{ "diagnostics" },
			{
				"diff",
				source = function()
					local status = vim.b.gitsigns_status_dict
					if status then
						return { added = status.added, modified = status.changed, removed = status.removed }
					end
				end,
			},
		},
		lualine_y = { { "progress", separator = " ", padding = { left = 1, right = 1 } } },
		lualine_z = { { "location", padding = { left = 1, right = 1 } } },
	},
})

vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
	callback = function()
		require("lualine").refresh()
	end,
})

require("incline").setup({
	window = {
		margin = { vertical = 0, horizontal = 1 },
		zindex = 10,
	},
	hide = { cursorline = "smart" },
	render = function(props)
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if vim.bo[props.buf].modified then
			filename = "[+] " .. filename
		end
		local icon, hl = MiniIcons.get("file", filename)
		return { { icon, group = hl }, { " " }, { filename } }
	end,
})

require("codediff").setup({
	explorer = {
		width = 50,
		auto_open_on_cursor = true,
		view_mode = "tree",
		line_stats = { enabled = true },
	},
	diff = {
		compact = true,
		compact_context_lines = 8,
		compact_sync_folds = true,
	},
})

-- neovim/neovim#40290: the treesitter fold module refreshes every tracked buffer
-- on 'foldminlines' changes without checking it is still valid. codediff's compact
-- mode sets that option on each file switch, which fails with "Invalid buffer id"
-- once a diff buffer has been wiped. Drop the refresh; it only matters when
-- 'foldminlines' or 'foldnestmax' change mid-session.
if pcall(require, "vim.treesitter._fold") then
	for _, au in ipairs(vim.api.nvim_get_autocmds({ event = "OptionSet" })) do
		if au.desc == "Refresh treesitter folds" then
			vim.api.nvim_del_autocmd(au.id)
		end
	end
end

local signs = { ERROR = "󰅚", WARN = "󰀪", INFO = "󰋽", HINT = "󰌶" }
vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = signs.ERROR,
			[vim.diagnostic.severity.WARN] = signs.WARN,
			[vim.diagnostic.severity.INFO] = signs.INFO,
			[vim.diagnostic.severity.HINT] = signs.HINT,
		},
	},
})
