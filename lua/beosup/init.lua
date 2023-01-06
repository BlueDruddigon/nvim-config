local M = {}

function M:init()
	-- Load user's options
	local options_status, options = pcall(require, "beosup.options")
	if not options_status then
		return
	end
	options.load_defaults()

	-- Load user's keymappings
	local keymaps_status, keymaps = pcall(require, "beosup.keymaps")
	if not keymaps_status then
		return
	end
	keymaps.load_defaults()

	-- Load user's plugins
	local plugins_status, plugins = pcall(require, "beosup.plugins")
	if not plugins_status then
		return
	end
	plugins:init()

	icons = require("beosup.icons")

	local colorscheme_status, _ = pcall(require, "beosup.colorscheme")
	if not colorscheme_status then
		return
	end
end

return M
