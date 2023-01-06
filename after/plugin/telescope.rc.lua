local status, telescope = pcall(require, "telescope")
if not status then
	return
end

local actions = require("telescope.actions")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")

local function get_pickers()
	return {
		find_files = {
			theme = "dropdown",
			hidden = true,
			previewer = false,
		},
		live_grep = {
			only_sort_text = true,
			theme = "dropdown",
		},
		grep_string = {
			only_sort_text = true,
			theme = "dropdown",
		},
		buffers = {
			theme = "dropdown",
			previewer = false,
			initial_mode = "normal",
			mappings = {
				i = {
					["<C-d>"] = actions.delete_buffer,
				},
				n = {
					["dd"] = actions.delete_buffer,
				},
			},
		},
		planets = {
			show_pluto = true,
			show_moon = true,
		},
		git_files = {
			theme = "dropdown",
			hidden = true,
			previewer = false,
			show_untracked = true,
		},
		lsp_references = {
			theme = "dropdown",
			initial_mode = "normal",
		},
		lsp_definitions = {
			theme = "dropdown",
			initial_mode = "normal",
		},
		lsp_declarations = {
			theme = "dropdown",
			initial_mode = "normal",
		},
		lsp_implementations = {
			theme = "dropdown",
			initial_mode = "normal",
		},
	}
end

telescope.setup({
	file_previewer = previewers.vim_buffer_cat.new,
	grep_previewer = previewers.vim_buffer_vimgrep.new,
	qflist_previewer = previewers.vim_buffer_qflist.new,
	file_sorter = sorters.get_fuzzy_file,
	generic_sorter = sorters.get_generic_fuzzy_sorter,
	defaults = {
		prompt_prefix = icons.ui.Telescope .. " ",
		selection_caret = icons.ui.Forward .. " ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "descending",
		layout_strategy = "horizontal",
		layout_config = {
			width = 0.75,
			preview_cutoff = 120,
			horizontal = {
				preview_width = function(_, cols, _)
					if cols < 120 then
						return math.floor(cols * 0.5)
					end
					return math.floor(cols * 0.6)
				end,
				mirror = false,
			},
			vertical = { mirror = false },
		},
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
			"--glob=!.git/",
		},
		mappings = {
			i = {
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-c>"] = actions.close,
				["<C-j>"] = actions.cycle_history_next,
				["<C-k>"] = actions.cycle_history_prev,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				["<CR>"] = actions.select_default,
			},
			n = {
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
			},
		},
		pickers = get_pickers(),
		file_ignore_patterns = {},
		path_display = { "smart" },
		winblend = 0,
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		set_env = { ["COLORTERM"] = "truecolor" },
	},
	pickers = get_pickers(),
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		media_files = {
			filetypes = { "png", "jpg", "jpeg", "webp" },
			find_cmd = "fd",
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("media_files")
