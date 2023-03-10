local status, nvimtree = pcall(require, "nvim-tree")
if not status then
	return
end

local function nvim_tree_start_telescope(telescope_mode)
	local node = require("nvim-tree.lib").get_node_at_cursor()
	if node == nil then
		return
	end
	local abspath = node.link_to or node.absolute_path
	local is_folder = node.open ~= nil
	local basedir = is_folder and abspath or vim.fn.fnamemodify(abspath, ":h")
	require("telescope.builtin")[telescope_mode]({
		cwd = basedir,
	})
end

local function telescope_find_files(_)
	nvim_tree_start_telescope("find_files")
end

local function telescope_live_grep(_)
	nvim_tree_start_telescope("live_grep")
end

nvimtree.setup({
	open_on_setup = true,
	ignore_ft_on_setup = {
		"startify",
		"dashboard",
		"alpha",
	},
	auto_reload_on_write = false,
	hijack_directories = {
		enable = false,
	},
	update_cwd = true,
	diagnostics = {
		enable = true,
		show_on_dirs = false,
		icons = {
			hint = icons.diagnostics.BoldHint,
			info = icons.diagnostics.BoldInformation,
			warning = icons.diagnostics.BoldWarning,
			error = icons.diagnostics.BoldError,
		},
	},
	update_focused_file = {
		enable = true,
		update_cwd = true,
		ignore_list = {},
	},
	system_open = {
		cmd = nil,
		args = {},
	},
	git = {
		enable = true,
		ignore = false,
		timeout = 200,
	},
	view = {
		width = 23,
		hide_root_folder = false,
		side = "left",
		mappings = {
			custom_only = false,
			list = {
				{ key = { "l", "<CR>", "o" }, action = "edit", mode = "n" },
				{ key = "h", action = "close_node" },
				{ key = "v", action = "vsplit" },
				{ key = "C", action = "cd" },
				{ key = "gtf", action = "telescope_find_files", action_cb = telescope_find_files },
				{ key = "gtg", action = "telescope_live_grep", action_cb = telescope_live_grep },
			},
		},
		number = false,
		relativenumber = false,
		signcolumn = "yes",
	},
	renderer = {
		indent_markers = {
			enable = false,
			icons = {
				corner = "└",
				edge = "│",
				item = "│",
				none = " ",
			},
		},
		icons = {
			webdev_colors = true,
			show = {
				git = false,
				folder = true,
				file = true,
				folder_arrow = true,
			},
			glyphs = {
				default = icons.ui.Text,
				symlink = icons.ui.FileSymlink,
				git = {
					deleted = icons.git.FileDeleted,
					ignored = icons.git.FileIgnored,
					renamed = icons.git.FileRenamed,
					staged = icons.git.FileStaged,
					unmerged = icons.git.FileUnmerged,
					unstaged = icons.git.FileUnstaged,
					untracked = icons.git.FileUntracked,
				},
				folder = {
					default = icons.ui.Folder,
					empty = icons.ui.EmptyFolder,
					empty_open = icons.ui.EmptyFolderOpen,
					open = icons.ui.FolderOpen,
					symlink = icons.ui.FolderSymlink,
				},
			},
		},
		highlight_git = true,
		group_empty = true,
		root_folder_modifier = ":t",
	},
	filters = {
		dotfiles = false,
		custom = { "node_modules", "\\.cache" },
		exclude = {},
	},
	trash = {
		cmd = "trash",
		require_confirm = true,
	},
	log = {
		enable = false,
		truncate = false,
		types = {
			all = false,
			config = false,
			copy_paste = false,
			diagnostics = false,
			git = false,
			profile = false,
		},
	},
	actions = {
		use_system_clipboard = true,
		change_dir = {
			enable = true,
			global = false,
			restrict_above_cwd = false,
		},
		open_file = {
			quit_on_open = true,
			resize_window = false,
			window_picker = {
				enable = false,
				chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
				exclude = {
					filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
					buftype = { "nofile", "terminal", "help" },
				},
			},
		},
	},
})
