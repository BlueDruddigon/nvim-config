local M = {}

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
	insert_mode = generic_opts_any,
	normal_mode = generic_opts_any,
	visual_mode = generic_opts_any,
	visual_block_mode = generic_opts_any,
	command_mode = generic_opts_any,
	term_mode = { silent = true },
}

local mode_adapters = {
	insert_mode = "i",
	normal_mode = "n",
	term_mode = "t",
	visual_mode = "v",
	visual_block_mode = "x",
	command_mode = "c",
}

local defaults = {
	insert_mode = {
		-- Move current line / block with Alt-j/k ala vscode.
		["<A-j>"] = "<Esc>:m .+1<CR>==gi",
		-- Move current line / block with Alt-j/k ala vscode.
		["<A-k>"] = "<Esc>:m .-2<CR>==gi",
		-- navigation
		["<A-Up>"] = "<C-\\><C-N><C-w>k",
		["<A-Down>"] = "<C-\\><C-N><C-w>j",
		["<A-Left>"] = "<C-\\><C-N><C-w>h",
		["<A-Right>"] = "<C-\\><C-N><C-w>l",
	},

	normal_mode = {
		-- Better window movement
		["<C-h>"] = "<C-w>h",
		["<C-j>"] = "<C-w>j",
		["<C-k>"] = "<C-w>k",
		["<C-l>"] = "<C-w>l",

		-- Resize with arrows
		["<C-Up>"] = ":resize +2<CR>",
		["<C-Down>"] = ":resize -2<CR>",
		["<C-Left>"] = ":vertical resize +2<CR>",
		["<C-Right>"] = ":vertical resize -2<CR>",

		-- Move current line / block with Alt-j/k a la vscode.
		["<A-j>"] = ":m .+1<CR>==",
		["<A-k>"] = ":m .-2<CR>==",

		-- Cycle through buffers
		["<S-l>"] = ":BufferLineCycleNext<CR>",
		["<S-h>"] = ":BufferLineCyclePrev<CR>",
	},

	term_mode = {
		-- Terminal window navigation
		["<C-h>"] = "<C-\\><C-N><C-w>h",
		["<C-j>"] = "<C-\\><C-N><C-w>j",
		["<C-k>"] = "<C-\\><C-N><C-w>k",
		["<C-l>"] = "<C-\\><C-N><C-w>l",
	},

	visual_mode = {
		-- Better indenting
		["<"] = "<gv",
		[">"] = ">gv",
	},

	visual_block_mode = {
		-- Move current line / block with Alt-j/k ala vscode.
		["<A-j>"] = ":m '>+1<CR>gv-gv",
		["<A-k>"] = ":m '<-2<CR>gv-gv",
	},

	command_mode = {
		-- navigate tab completion with <c-j> and <c-k>
		-- runs conditionally
		["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
		["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
	},
}

if vim.fn.has("mac") == 1 then
	defaults.normal_mode["<A-Up>"] = defaults.normal_mode["<C-Up>"]
	defaults.normal_mode["<A-Down>"] = defaults.normal_mode["<C-Down>"]
	defaults.normal_mode["<A-Left>"] = defaults.normal_mode["<C-Left>"]
	defaults.normal_mode["<A-Right>"] = defaults.normal_mode["<C-Right>"]
end

function M.set_keymaps(mode, key, value)
	local option = generic_opts[mode] or generic_opts_any
	if type(value) == "table" then
		option = value[2]
		value = value[1]
	end
	if value then
		vim.keymap.set(mode, key, value, option)
	else
		pcall(vim.api.nvim_del_keymap, mode, key)
	end
end

function M.load_mode(mode, keymaps)
	mode = mode_adapters[mode] or mode
	for k, v in pairs(keymaps) do
		M.set_keymaps(mode, k, v)
	end
end

function M.load(keymaps)
	keymaps = keymaps or {}
	for mode, mapping in pairs(keymaps) do
		M.load_mode(mode, mapping)
	end
end

function M.load_defaults()
	M.load(M.get_defaults())
end

function M.get_defaults()
	return defaults
end

return M
