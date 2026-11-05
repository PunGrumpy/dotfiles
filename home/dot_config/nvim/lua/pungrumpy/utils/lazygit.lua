local M = {}

-- Files opened from inside lazygit go to the window it was launched from, so
-- the float closes and the file lands where the review started.
local origin_win ---@type integer?

function M.open()
	origin_win = vim.api.nvim_get_current_win()
	Snacks.lazygit()
end

function M.focus_origin()
	if origin_win and vim.api.nvim_win_is_valid(origin_win) then
		pcall(vim.api.nvim_set_current_win, origin_win)
	end
end

local server = 'nvim --server "$NVIM"'
local focus_origin = server .. [[ --remote-send '<Cmd>lua require("pungrumpy.utils.lazygit").focus_origin()<CR>']]

--- Builds a lazygit `os.edit` / `os.editAtLine` command in fish syntax, which
--- is what lazygit runs here because it takes the shell from $SHELL.
---@param at_line? boolean also jump to `{{line}}`
---@return string
function M.edit_command(at_line)
	local outside = at_line and "nvim +{{line}} -- {{filename}}" or "nvim -- {{filename}}"
	local inside = {
		server .. ' --remote-send "q"',
		focus_origin,
		server .. " --remote {{filename}}",
	}
	if at_line then
		inside[#inside + 1] = server .. ' --remote-send ":{{line}}<CR>"'
	end
	return ('if test -z "$NVIM"; %s; else; %s; end'):format(outside, table.concat(inside, "; "))
end

return M
