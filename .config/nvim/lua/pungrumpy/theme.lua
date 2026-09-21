local M = {}

M.name = vim.env.DOTFILES_THEME == "solarized-osaka" and "solarized-osaka" or "vercel"
M.is_vercel = M.name == "vercel"
M.colorscheme = M.is_vercel and "github_dark_default" or "solarized-osaka"

function M.incline_groups()
	if M.is_vercel then
		return {
			InclineNormal = { guibg = "#c472fb", guifg = "#000000" },
			InclineNormalNC = { guifg = "#a1a1a1", guibg = "#1a1a1a" },
		}
	end
	local colors = require("solarized-osaka.colors").setup()
	return {
		InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
		InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
	}
end

return M
