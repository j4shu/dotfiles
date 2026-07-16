local servers = {
  tombi = {},
  lua_ls = {
    settings = {
      Lua = {
        hint = { enable = false },
        diagnostics = {
          disable = { 'missing-fields' },
          globals = { 'vim' },
        },
      },
    },
  },
  basedpyright = {
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = 'basic',
          diagnosticMode = 'openFilesOnly',
        },
      },
    },
  },
}

for server, config in pairs(servers) do
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

-- maps
vim.keymap.set('n', 'gs', vim.lsp.buf.hover, { desc = 'LSP: Hover' })
vim.keymap.set('n', 'gR', vim.lsp.buf.rename, { desc = 'LSP: Rename Variable' })

-- diagnostics
vim.keymap.set('n', 'gD', vim.diagnostic.open_float, { desc = 'LSP: Hover Diagnostic' })
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled(), { bufnr = 0 })
end, { desc = 'LSP: Toggle Diagnostics' })

-- delete default gr-prefix LSP maps
for _, lhs in ipairs({ 'grn', 'grr', 'gri', 'grt', 'grx' }) do
  pcall(vim.keymap.del, 'n', lhs)
end
pcall(vim.keymap.del, { 'n', 'x' }, 'gra')
