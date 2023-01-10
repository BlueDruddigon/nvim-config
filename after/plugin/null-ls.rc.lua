local status, null_ls = pcall(require, "null-ls")
if not status then
  return
end

local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

local sources = {
  -- python
  diagnostics.flake8,
  diagnostics.pylint,
  formatting.yapf,
  formatting.isort,
  -- lua
  formatting.stylua,
  -- js, jsx, ts, tsx
  formatting.prettier,
  diagnostics.eslint,
  code_actions.eslint,
  -- markdown
  diagnostics.write_good,
  code_actions.proselint,
}

null_ls.setup({
  debug = true,
  sources = sources,
  diagnostics_format = "[#{c}] #{m} (#{s})",
})
