local M = {}

local MAX_NAME = 20

local function set_highlights()
	local function get(name, attr)
		return vim.api.nvim_get_hl(0, { name = name, link = false })[attr]
	end
	vim.api.nvim_set_hl(0, "TabLineInactive", { fg = get("Comment", "fg"), bg = get("TabLine", "bg") })
end

local function label(tab)
	local buf = vim.fn.tabpagebuflist(tab)[vim.fn.tabpagewinnr(tab)]
	local name = vim.api.nvim_buf_get_name(buf)
	local icon = ""
	if vim.bo[buf].buftype == "terminal" then
		name = "[Terminal]"
	elseif vim.bo[buf].filetype == "oil" then
		name = vim.fn.fnamemodify((name:gsub("^oil://", "")), ":~")
	elseif name == "" then
		name = "[No Name]"
	else
		name = vim.fn.fnamemodify(name, ":t")
		icon = MiniIcons.get("file", name) .. " "
	end
	if #name > MAX_NAME then
		name = name:sub(1, MAX_NAME - 3) .. "…"
	end
	return ("%s%s%s"):format(icon, vim.bo[buf].modified and "[+] " or "", name)
end

function M.render()
	local current = vim.fn.tabpagenr()
	local parts = {}
	for tab = 1, vim.fn.tabpagenr("$") do
		local hl = tab == current and "%#TabLineSel#" or "%#TabLineInactive#"
		parts[#parts + 1] = ("%%%dT%s  %s  "):format(tab, hl, label(tab))
	end
	return table.concat(parts) .. "%T%#TabLineFill#"
end

function M.setup()
	set_highlights()
	vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })
	vim.o.showtabline = 1
	vim.o.tabline = "%!v:lua.require('pungrumpy.utils.tabline').render()"
end

return M
