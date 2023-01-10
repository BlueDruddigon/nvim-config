vim.bo.shiftwidth = 4
vim.bo.tabstop = 4

-- KiteLSP
vim.api.nvim_create_user_command("KiteLSP", function()
	vim.lsp.start({
		name = "kite-lsp",
		cmd = { "kite-lsp", "--editor=vim", "--stdio" },
		whitelist = { "python", "javascript" },
		autostart = true,
	})
end, {})

vim.cmd("KiteLSP")
