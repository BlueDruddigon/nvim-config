local M = {}

M.load_defaults = function()
	local undodir = vim.fn.stdpath("cache") .. "/undodir"

	local default_options = {
		backup = false,
		clipboard = "unnamedplus",
		cmdheight = 1,
		completeopt = { "menuone", "noselect" },
		conceallevel = 0,
		fileencoding = "utf-8",
		foldmethod = "expr",
		foldexpr = "nvim_treesitter#foldexpr()",
		foldenable = false,
		guifont = "monospace:h17",
		hidden = true,
		hlsearch = true,
		ignorecase = true,
		mouse = "a",
		pumheight = 10,
		showmode = false,
		showtabline = 2,
		smartcase = true,
		splitbelow = true,
		splitright = true,
		swapfile = false,
		termguicolors = true,
		timeoutlen = 1000,
		title = true,
		undodir = undodir,
		undofile = true,
		updatetime = 100,
		writebackup = false,
		expandtab = true,
		shiftwidth = 2,
		tabstop = 2,
		cursorline = true,
		number = true,
		numberwidth = 4,
		signcolumn = "yes",
		wrap = false,
		scrolloff = 8,
		sidescrolloff = 8,
		showcmd = false,
		ruler = false,
		laststatus = 3,
	}

	vim.opt.spelllang:append("cjk")
	vim.opt.shortmess:append("c")
	vim.opt.shortmess:append("I")
	vim.opt.whichwrap:append("<,>,[,],h,l")

	for k, v in pairs(default_options) do
		vim.opt[k] = v
	end

	vim.g.mapleader = " "
end

return M
