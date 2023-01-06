local status, tokyonight = pcall(require, "tokyonight")
if not status then
	return
end

tokyonight.setup({
	style = "storm",
	light_style = "storm",
	transparent = true,
	terminal_colors = true,
	styles = {
		comments = { italic = true },
		keywords = { italic = true },
		functions = {},
		variables = {},
		sidebars = "dark",
		floats = "dark",
	},
	sidebars = { "qf", "help" },
	day_brightness = 0.3,
	hide_inactive_statusline = false,
	dim_inactive = false,
	lualine_bold = false,

	on_colors = function(_) end,
	on_highlights = function(_, _) end,
})
