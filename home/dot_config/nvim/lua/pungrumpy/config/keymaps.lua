local discipline = require("pungrumpy.discipline")
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

discipline.ghosty()

-- Edit without touching the unnamed register
keymap.set("n", "x", '"_x')
keymap.set({ "n", "v" }, "<Leader>p", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set({ "n", "v" }, "<Leader>c", '"_c')
keymap.set({ "n", "v" }, "<Leader>C", '"_C')
keymap.set({ "n", "v" }, "<Leader>d", '"_d')
keymap.set({ "n", "v" }, "<Leader>D", '"_D')

keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")
keymap.set("n", "dw", 'vb"_d')
keymap.set("n", "<C-a>", "gg<S-v>G")

keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Terminals send Enter as <C-m>, so keep Enter working in quickfix, help and other special buffers.
map("n", "<C-m>", function()
	return vim.bo.buftype == "" and "<C-i>" or "<CR>"
end, { expr = true, desc = "Jump forward" })

keymap.set("n", "te", ":tabedit<CR>")
keymap.set("n", "<tab>", ":tabnext<CR>", opts)
keymap.set("n", "<s-tab>", ":tabprev<CR>", opts)

keymap.set("n", "ss", ":split<CR>", opts)
keymap.set("n", "sv", ":vsplit<CR>", opts)
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

keymap.set("n", "<leader>r", function()
	require("pungrumpy.hsl").replaceHexWithHSL()
end, { desc = "Replace hex colors on the line with HSL" })

keymap.set("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-- Copies `path#L<line>` for pasting into an agent prompt.
local function yank_path_with_line(modifier, label)
	return function()
		if vim.api.nvim_buf_get_name(0) == "" then
			vim.notify("Buffer has no file name", vim.log.levels.WARN)
			return
		end
		local path = vim.fn.expand(modifier):gsub("\\", "/")
		local ref = ("%s#L%d"):format(path, vim.fn.line("."))
		vim.fn.setreg("+", ref)
		vim.notify(("Yanked %s path: %s"):format(label, ref))
	end
end

keymap.set("n", "<leader>yf", yank_path_with_line("%:.", "relative"), { desc = "Yank relative path with line number" })
keymap.set("n", "<leader>yp", yank_path_with_line("%:p", "absolute"), { desc = "Yank absolute path with line number" })
