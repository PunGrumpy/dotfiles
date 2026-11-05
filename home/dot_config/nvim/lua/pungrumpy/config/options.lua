vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = false
opt.title = true
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 10
opt.sidescrolloff = 8

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

opt.termguicolors = true
opt.signcolumn = "yes"
opt.showmatch = true
opt.matchtime = 2
opt.cmdheight = 0
opt.laststatus = 3
opt.completeopt = "menuone,noinsert,noselect"
opt.pumheight = 10
opt.pumblend = 10
opt.winborder = "rounded"
opt.fillchars:append("diff:╱")
opt.guicursor =
	"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.updatetime = 300
opt.timeoutlen = 500
opt.ttimeoutlen = 0

opt.iskeyword:append("-")
opt.path:append("**")
opt.wildignore:append({ "*/node_modules/*", "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })
opt.wildmode = "longest:full,full"
opt.mouse = ""
opt.clipboard:append("unnamedplus")
opt.formatoptions:append("r")

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99

opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"

if vim.fn.executable("fish") == 1 then
	opt.shell = "fish"
end

if vim.env.WSL_DISTRO_NAME then
	vim.g.clipboard = {
		name = "clip",
		copy = {
			["+"] = "clip.exe",
			["*"] = "clip.exe",
		},
		paste = {
			["+"] = "powershell.exe -NoProfile -Command Get-Clipboard",
			["*"] = "powershell.exe -NoProfile -Command Get-Clipboard",
		},
		cache_enabled = 1,
	}
end

require("vim._core.ui2").enable({
	msg = {
		targets = {
			[""] = "msg",
			empty = "cmd",
			bufwrite = "msg",
			confirm = "cmd",
			emsg = "pager",
			echo = "msg",
			echomsg = "msg",
			echoerr = "pager",
			completion = "cmd",
			list_cmd = "pager",
			lua_error = "pager",
			lua_print = "msg",
			progress = "pager",
			rpc_error = "pager",
			quickfix = "msg",
			search_cmd = "cmd",
			search_count = "cmd",
			shell_cmd = "pager",
			shell_err = "pager",
			shell_out = "pager",
			shell_ret = "msg",
			undo = "msg",
			verbose = "pager",
			wildlist = "cmd",
			wmsg = "msg",
			typed_cmd = "cmd",
		},
		cmd = { height = 0.5 },
		dialog = { height = 0.5 },
		msg = { height = 0.3, timeout = 5000 },
		pager = { height = 0.5 },
	},
})
