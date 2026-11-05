vim.api.nvim_create_user_command("ToggleFormatter", function()
	local disabled = not vim.b.disable_autoformat
	vim.b.disable_autoformat = disabled
	vim.notify("Formatter " .. (disabled and "disabled" or "enabled") .. " for this buffer")
end, { desc = "Toggle format on save for the current buffer" })
