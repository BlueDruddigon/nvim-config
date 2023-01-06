local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

local nlsp_settings_status, nlsp_settings = pcall(require, "nlspsettings")
if not nlsp_settings_status then
	return
end

nlsp_settings.setup({
	config_home = vim.fn.stdpath("config") .. "/lsp-settings",
	append_default_schemas = true,
	ignored_servers = {},
	loader = "json",
})

local diagnostics_float_config = {
	focusable = false,
	style = "minimal",
	border = "rounded",
	source = "always",
	header = "",
	prefix = "",
	format = function(d)
		local code = d.code or (d.user_data and d.user_data.lsp.code)
		if code then
			return string.format("%s [%s]", d.message, code):gsub("1. ", "")
		end
		return d.message
	end,
}

local augroup_format = vim.api.nvim_create_augroup("LspFormat", { clear = true })
local enable_format_on_save = function(_, bufnr)
	vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = augroup_format,
		buffer = bufnr,
		callback = function()
			vim.lsp.buf.format({ bufnr = bufnr })
		end,
	})
end

-- Setup CodeLens
local setup_codelens_refresh = function(client, bufnr)
	local status_ok, codelens_supported = pcall(function()
		return client.supports_method("textDocument/codeLens")
	end)
	if not status_ok or not codelens_supported then
		return
	end
	local group = "lsp_code_lens_refresh"
	local cl_events = { "BufEnter", "InsertLeave" }
	local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
		group = group,
		buffer = bufnr,
		event = cl_events,
	})

	if ok and #cl_autocmds > 0 then
		return
	end
	vim.api.nvim_create_augroup(group, { clear = false })
	vim.api.nvim_create_autocmd(cl_events, {
		group = group,
		buffer = bufnr,
		callback = vim.lsp.codelens.refresh,
	})
end

-- Setup Document Symbols
local setup_document_symbols = function(client, bufnr)
	vim.g.navic_silence = false -- can be set to true to suppress error
	local symbols_supported = client.supports_method("textDocument/documentSymbol")
	if not symbols_supported then
		return
	end
	local status_ok, navic = pcall(require, "nvim-navic")
	if status_ok then
		navic.attach(client, bufnr)
	end
end

local on_attach = function(client, bufnr)
	local buffer_options = {
		omnifunc = "v:lua.vim.lsp.omnifunc",
		formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:200})",
	}

	for k, v in pairs(buffer_options) do
		vim.api.nvim_buf_set_option(bufnr, k, v)
	end

	local buffer_mappings = {
		normal_mode = {
			["K"] = { vim.lsp.buf.hover, "Show Hover" },
			["gd"] = { vim.lsp.buf.definition, "Goto Definition" },
			["gD"] = { vim.lsp.buf.declaration, "Goto Declaration" },
			["gr"] = { vim.lsp.buf.references, "Goto References" },
			["gI"] = { vim.lsp.buf.implementation, "Goto Implementation" },
			["gs"] = { vim.lsp.buf.signature_help, "Show Signature Help" },
			["gl"] = {
				function()
					local config = diagnostics_float_config
					config.scope = "line"
					vim.diagnostic.open_float(0, config)
				end,
				"Show Line Diagnostics",
			},
		},
		insert_mode = {},
		visual_mode = {},
	}

	local mappings = {
		normal_mode = "n",
		insert_mode = "i",
		visual_mode = "v",
	}

	for mode_name, mode_char in pairs(mappings) do
		for key, remap in pairs(buffer_mappings[mode_name]) do
			local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
			vim.keymap.set(mode_char, key, remap[1], opts)
		end
	end

	setup_codelens_refresh(client, bufnr)
	setup_document_symbols(client, bufnr)
	enable_format_on_save(_, bufnr)
end

local function common_capabilities()
	local cmp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if cmp_status then
		return cmp_nvim_lsp.default_capabilities()
	end

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}

	return capabilities
end

local on_exit = function(_, _)
	vim.schedule(function()
		pcall(function()
			vim.api.nvim_clear_autocmds({ group = "lsp_code_lens_refresh" })
		end)
	end)
end

local capabilities = common_capabilities()

-- JsonLSP
lspconfig["jsonls"].setup({
	on_attach = on_attach,
	on_exit = on_exit,
	capabilities = capabilities,
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

-- Sumneko Lua LSP
lspconfig["sumneko_lua"].setup({
	on_attach = on_attach,
	on_exit = on_exit,
	capabilities = capabilities,
	settings = {
		Lua = {
			telemetry = { enable = false },
			runtime = {
				version = "LuaJIT",
				special = {
					reload = "require",
				},
			},
			diagnostics = {
				globals = { "vim", "icons" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
})

-- Pyright LSP
lspconfig["pyright"].setup({
	on_attach = on_attach,
	on_exit = on_exit,
	capabilities = capabilities,
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_dir = function(fname)
		local util = lspconfig.util
		local root_files = {
			"pyproject.toml",
			"setup.py",
			"setup.cfg",
			"requirements.txt",
			"Pipfile",
			"manage.py",
			"pyrightconfig.json",
			".git",
			".gitignore",
			"pylintrc",
			"README.md",
			"LICENSE",
		}
		return util.root_pattern(unpack(root_files))(fname)
	end,
	single_file_support = true,
})

-- Tsserver LSP
lspconfig["tsserver"].setup({
	on_attach = on_attach,
	on_exit = on_exit,
	capabilities = capabilities,
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
})

-- TailwindCSS LSP
lspconfig["tailwindcss"].setup({
	on_attach = on_attach,
	on_exit = on_exit,
	capabilities = capabilities,
})

-- CSS LSP
lspconfig["cssls"].setup({
	on_attach = on_attach,
	on_exit = on_exit,
	capabilities = capabilities,
})

-- Astro LSP
lspconfig["astro"].setup({
	on_attach = on_attach,
	on_exit = on_exit,
	capabilities = capabilities,
})

-- DiagnosticSymbols
local signs = {
	Error = icons.diagnostics.Error,
	Warn = icons.diagnostics.Warning,
	Hint = icons.diagnostics.Hint,
	Info = icons.diagnostics.Info,
}
for type, icon in pairs(signs) do
	local hl = "diagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local config = {
	virtual_text = true,
	update_in_insert = false,
	severity_sort = true,
	underline = true,
	float = diagnostics_float_config,
}

vim.diagnostic.config(config)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	focusable = true,
	style = "minimal",
	border = "rounded",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	focusable = true,
	style = "minimal",
	border = "rounded",
})
