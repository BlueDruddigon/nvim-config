local status, trouble = pcall(require, "trouble")
if not status then
	return
end

trouble.setup({
	auto_close = true,
	auto_open = false,
	auto_preview = true,
	use_diagnostic_signs = true,
	mode = "document_diagnostics",
	action_keys = {
		jump_close = { "<CR>", "o", "<TAB>" },
		jump = {},
	},
})

vim.api.nvim_set_keymap("n", "ge", "<CMD>TroubleToggle<CR>", { noremap = true, silent = true })
