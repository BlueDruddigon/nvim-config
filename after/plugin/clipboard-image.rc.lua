local status, clipboard_image = pcall(require, "clipboard-image")
if not status then
	return
end

clipboard_image.setup()
