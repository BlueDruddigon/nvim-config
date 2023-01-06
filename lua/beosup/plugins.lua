local M = {}

local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer. Close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

local status, packer = pcall(require, "packer")
if not status then
	return
end

-- Packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

function M:init()
	return packer.startup(function(use)
		-- Packer.nvim handle itself
		use("wbthomason/packer.nvim")

		-- My plugins
		-- Popup APIs
		use("nvim-lua/popup.nvim")
		-- Useful lua functions
		use("nvim-lua/plenary.nvim")

		-- colorscheme
		use("folke/tokyonight.nvim")

		-- Autocompletions
		use("hrsh7th/nvim-cmp")
		-- Buffer completions
		use("hrsh7th/cmp-buffer")
		-- Path completions
		use("hrsh7th/cmp-path")
		-- snippet completions
		use("saadparwaiz1/cmp_luasnip")
		-- Completion of LSP
		use("hrsh7th/cmp-nvim-lsp")

		-- Snippets engine
		use("L3MON4D3/LuaSnip")

		-- File Explorer
		use({
			"nvim-tree/nvim-tree.lua",
			requires = { "nvim-tree/nvim-web-devicons" },
			tag = "nightly",
		})

		-- LSP
		use("neovim/nvim-lspconfig")
		-- language server installer
		use("williamboman/mason.nvim")
		-- language server configurations
		use("williamboman/mason-lspconfig.nvim")
		-- LSP utilities for diagnostics, formatting and code actions
		use("jose-elias-alvarez/null-ls.nvim")
		-- LspSettings using json
		use("tamago324/nlsp-settings.nvim")

		-- Bufferline
		use("akinsho/bufferline.nvim")
		-- Statusline
		use("nvim-lualine/lualine.nvim")

		-- Commenter
		use({
			"numToStr/Comment.nvim",
			requires = { "JoosepAlviste/nvim-ts-context-commentstring" },
		})

		-- Telescope and plugins
		use({
			"nvim-telescope/telescope.nvim",
			tag = "0.1.x",
		})
		use({
			"nvim-telescope/telescope-fzf-native.nvim",
			run = "make",
			requires = { "nvim-telescope/telescope.nvim" },
		})
		use({
			"nvim-telescope/telescope-media-files.nvim",
			requires = { "nvim-telescope/telescope.nvim" },
		})

		-- Treesitter and plugins
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
		})
		use("p00f/nvim-ts-rainbow")
		use("nvim-treesitter/playground")
		use("JoosepAlviste/nvim-ts-context-commentstring")
		use("windwp/nvim-ts-autotag")
		use("andymass/vim-matchup")
		use("romgrk/nvim-treesitter-context")

		-- breadcrumbs
		use("SmiteshP/nvim-navic")
		-- Schemastore
		use("b0o/schemastore.nvim")

		-- Find and Replace
		use("nvim-pack/nvim-spectre")
		-- Colorizer
		use("norcalli/nvim-colorizer.lua")
		-- Trouble Finder
		use({
			"folke/trouble.nvim",
			requires = { "kyazdani42/nvim-web-devicons" },
		})
		-- Markdown supports
		use("ellisonleao/glow.nvim")
		use({
			"iamcco/markdown-preview.nvim",
			run = function()
				vim.fn["mkdp#util#install"]()
			end,
		})

		-- Clipboard image
		use("ekickx/clipboard-image.nvim")
		-- autopairs
		use("windwp/nvim-autopairs")

		-- Which-key for better keybindings
		use("folke/which-key.nvim")

		if PACKER_BOOTSTRAP then
			require("packer").sync()
		end
	end)
end

return M
