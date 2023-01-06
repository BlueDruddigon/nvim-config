local status, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not status then
	return
end

local opts = {
	ensure_installed = {
		"python",
		"bash",
		"typescript",
		"javascript",
		"html",
		"css",
		"scss",
		"c",
		"cpp",
		"rust",
		"lua",
		"markdown",
	},
	ignore_install = {},
	parser_install_dir = nil,
	sync_install = true,
	auto_install = true,
	matchup = {
		enable = true,
		matchup_matchparen_offscreen = { method = "popup" },
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
		disable = function(lang, buf)
			if vim.tbl_contains({ "latex" }, lang) then
				return true
			end

			local max_filesize = 1024 * 1024
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				vim.schedule(function()
					vim.api.nvim_buf_call(buf, function()
						vim.cmd("setlocal noswapfile noundofile")

						if vim.tbl_contains({ "json" }, lang) then
							vim.cmd("NoMatchParen")
							vim.cmd("syntax off")
							vim.cmd("syntax clear")
							vim.cmd("setlocal nocursorline nolist bufhidden=unload")

							vim.api.nvim_create_autocmd({ "BufDelete" }, {
								callback = function()
									vim.cmd("DoMatchParen")
									vim.cmd("syntax on")
								end,
								buffer = buf,
							})
						end
					end)
				end)
				return true
			end
		end,
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
		config = {
			typescript = "// %s",
			css = "/* %s */",
			scss = "/* %s */",
			html = "<!-- %s -->",
			svelte = "<!-- %s -->",
			vue = "<!-- %s -->",
			json = "",
		},
	},
	indent = { enable = false },
	autotag = { enable = true },
	textobjects = {
		swap = {
			enable = false,
		},
		select = {
			enable = false,
		},
	},
	textsubjects = {
		enable = false,
		keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-big" },
	},
	playground = {
		enable = true,
		disable = {},
		updatetime = 250,
		persist_queries = false,
		keybindings = {
			toggle_query_editor = "o",
			toggle_hl_groups = "i",
			toggle_injected_languages = "t",
			toggle_anonymous_nodes = "a",
			toggle_language_display = "I",
			focus_language = "f",
			unfocus_language = "F",
			update = "R",
			goto_node = "<cr>",
			show_help = "?",
		},
	},
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = 1000,
	},
}

treesitter_configs.setup(opts)
