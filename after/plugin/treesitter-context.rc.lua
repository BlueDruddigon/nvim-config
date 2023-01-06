local status, context = pcall(require, "treesitter-context")
if not status then
	return
end

context.setup({
	enable = true,
	throttle = true,
	max_lines = 0,
	patterns = {
		default = {
			"class",
			"function",
			"method",
		},
	},
})
