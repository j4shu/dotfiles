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

-- work
-- if vim.env.SSH_CLIENT ~= nil then
--   servers.basedpyright.settings.python = {
--     pythonPath = '/u/jshu/p4/cacl3/test/tools/python/nate/rhel7-3.12/bin/python',
--   }
-- end

for server, config in pairs(servers) do
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

-- maps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP: Definition' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'LSP: References' })
vim.keymap.set('n', 'gs', vim.lsp.buf.hover, { desc = 'LSP: Hover' })
vim.keymap.set('n', 'gR', vim.lsp.buf.rename, { desc = 'LSP: Rename Variable' })

-- -- lsp info
-- vim.keymap.set('n', '<leader>li', '<cmd>LspInfo<CR>', { desc = 'LSP: Info' })
-- vim.keymap.set('n', '<leader>lr', function()
--   vim.notify('LSP: Restarting...')
--   vim.cmd('LspRestart')
-- end, { desc = 'LSP: Restart' })
-- vim.keymap.set('n', '<leader>ll', '<cmd>LspLog<CR><cmd>norm! G<cr>', { desc = 'LSP: Log' })
--
-- -- inlay hints
-- vim.keymap.set('n', '<leader>ti', function()
--   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
-- end, { desc = 'LSP: Toggle Inlay Hints' })
--
-- -- diagnostics
-- vim.keymap.set('n', 'gD', vim.diagnostic.open_float, { desc = 'LSP: Hover Diagnostic' })
-- vim.keymap.set('n', '<leader>td', function()
--   vim.diagnostic.enable(not vim.diagnostic.is_enabled(), { bufnr = 0 })
-- end, { desc = 'LSP: Toggle Diagnostics' })
--
-- -- delete bad defaults
-- if vim.fn.has('nvim-0.11') == 1 then
--   pcall(vim.keymap.del, 'n', 'grr')
--   pcall(vim.keymap.del, 'n', 'gri')
--   pcall(vim.keymap.del, 'n', 'grn')
--   pcall(vim.keymap.del, { 'n', 'x' }, 'grr')
--   pcall(vim.keymap.del, { 'n', 'x' }, 'gra')
-- end
