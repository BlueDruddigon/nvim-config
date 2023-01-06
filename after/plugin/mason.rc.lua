local mason_status, mason = pcall(require, "mason")
if not mason_status then
	return
end

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	return
end

mason.setup()

mason_lspconfig.setup({
	automatic_installation = true,
	ensure_installed = {
		"sumneko_lua",
		"rust_analyzer",
		"yamlls",
		"jsonls",
	},
})
