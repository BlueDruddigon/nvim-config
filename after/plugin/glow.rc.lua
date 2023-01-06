local status, glow = pcall(require, "glow")
if not status then
	return
end

glow.setup({
	style = "light",
	width = 120,
})
