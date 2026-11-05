local map = vim.keymap.set
local picker = Snacks.picker

map("n", "sf", function()
	require("oil").open_float(nil, { preview = {} })
end, { desc = "File explorer" })

-- LSP
local function goto_source_definition()
	local client = vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })[1]
	if not client then
		return vim.lsp.buf.implementation()
	end
	local params = vim.lsp.util.make_position_params(0, "utf-16")
	client:request("workspace/executeCommand", {
		command = "typescript.goToSourceDefinition",
		arguments = { params.textDocument.uri, params.position },
	}, function(err, result)
		if err then
			vim.notify("goToSourceDefinition: " .. err.message, vim.log.levels.ERROR)
		elseif result and #result > 0 then
			vim.lsp.util.show_document(result[1], "utf-16", { focus = true })
		else
			vim.notify("No source definition found")
		end
	end, 0)
end

map("n", "gd", function()
	picker.lsp_definitions({ jump = { reuse_win = false } })
end, { desc = "Goto definition" })
map("n", "gD", picker.lsp_declarations, { desc = "Goto declaration" })
map("n", "gy", picker.lsp_type_definitions, { desc = "Goto type definition" })
map("n", "gr", picker.lsp_references, { desc = "References" })
map("n", "gI", goto_source_definition, { desc = "Goto source definition / implementation" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "<c-j>", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map({ "n", "x" }, "<leader>f", function()
	require("conform").format()
end, { desc = "Format" })

-- Pickers
map("n", "<leader>cl", picker.lsp_config, { desc = "LSP info" })
map("n", "<leader>cR", Snacks.rename.rename_file, { desc = "Rename file" })
map("n", ";f", picker.files, { desc = "Find files" })
map("n", ";r", picker.grep, { desc = "Live grep" })
map("n", ";;", picker.resume, { desc = "Resume picker" })
map("n", ";e", picker.diagnostics, { desc = "Diagnostics" })
map("n", ";c", picker.lsp_incoming_calls, { desc = "LSP incoming calls" })
map("n", ";s", picker.treesitter, { desc = "Treesitter symbols" })
map("n", ";t", picker.help, { desc = "Help tags" })
map("n", ";n", picker.notifications, { desc = "Notifications" })
map("n", ";h", picker.git_diff, { desc = "Git diff (hunks)" })
map("n", "\\\\", function()
	picker.buffers({
		confirm = function(p, item)
			p:close()
			if not item then
				return
			end
			-- Jump to the window already showing the buffer, in any tab, instead of opening it here.
			vim.schedule(function()
				for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
					for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
						if vim.api.nvim_win_get_buf(win) == item.buf then
							vim.api.nvim_set_current_tabpage(tab)
							vim.api.nvim_set_current_win(win)
							return
						end
					end
				end
				vim.api.nvim_set_current_buf(item.buf)
			end)
		end,
	})
end, { desc = "Buffers" })
map({ "n", "t" }, "]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })
map({ "n", "t" }, "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Previous reference" })

-- Review flow
map("n", ";g", function()
	require("pungrumpy.utils.lazygit").open()
end, { desc = "Lazygit" })
map("n", "<leader>dv", "<cmd>CodeDiff<cr>", { desc = "CodeDiff" })
map("n", "<leader>dh", "<cmd>CodeDiff history %<cr>", { desc = "File history (current file)" })
map("n", "<leader>dH", "<cmd>CodeDiff history<cr>", { desc = "File history (repo)" })
map("n", "<leader>gd", function()
	require("mini.diff").toggle_overlay()
end, { desc = "Toggle mini.diff overlay" })

-- Git
map("n", "<leader>gb", function()
	require("gitsigns").blame_line()
end, { desc = "Blame line" })
map("n", "<leader>gB", function()
	require("gitsigns").blame()
end, { desc = "Blame buffer" })
map("n", "<leader>gh", function()
	require("gitsigns").stage_hunk()
end, { desc = "Toggle stage hunk" })
map("n", "<leader>gs", function()
	local gitsigns = require("gitsigns")
	if #(gitsigns.get_hunks() or {}) > 0 then
		gitsigns.stage_buffer()
	else
		gitsigns.reset_buffer_index()
	end
end, { desc = "Toggle stage buffer" })
map({ "n", "v" }, "<leader>gy", "<cmd>GitLink<cr>", { desc = "Yank git link" })
map({ "n", "v" }, "<leader>gY", "<cmd>GitLink!<cr>", { desc = "Open git link" })
