local status, spectre = pcall(require, "spectre")
if not status then
	return
end

spectre.setup({})

vim.api.nvim_set_keymap("n", "<C-f>", "<CMD>lua require('spectre').open()<CR>", { noremap = true, silent = true })
