local servers = {
  marksman = {},
  taplo = {},
  lua_ls = {
    settings = {
      Lua = {
        hint = { enable = true },
        diagnostics = {
          disable = { 'missing-fields' },
          globals = { 'vim', 'hs' },
        },
      },
    },
  },
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        checkOnSave = {
          command = 'clippy',
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
  gopls = {},
}

-- work
if vim.env.SSH_CLIENT ~= nil then
  servers.basedpyright.settings.python = {
    pythonPath = '/u/jshu/p4/cacl3/test/tools/python/nate/rhel7-3.12/bin/python',
  }
end

-- lspconfig
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local lspconfig = require('lspconfig')
for server, config in pairs(servers) do
  -- config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
  config.capabilities = capabilities
  -- lspconfig[server].setup(config)
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

-- maps
vim.keymap.set('n', 'gs', vim.lsp.buf.hover, { desc = 'LSP: Hover' })
vim.keymap.set('n', 'gR', vim.lsp.buf.rename, { desc = 'LSP: Rename Variable' })

-- lsp info
vim.keymap.set('n', '<leader>li', '<cmd>LspInfo<CR>', { desc = 'LSP: Info' })
vim.keymap.set('n', '<leader>lr', function()
  vim.notify('LSP: Restarting...')
  vim.cmd('LspRestart')
end, { desc = 'LSP: Restart' })
vim.keymap.set('n', '<leader>ll', '<cmd>LspLog<CR><cmd>norm! G<cr>', { desc = 'LSP: Log' })

-- inlay hints
vim.keymap.set('n', '<leader>ti', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'LSP: Toggle Inlay Hints' })

-- diagnostics
vim.keymap.set('n', 'gD', vim.diagnostic.open_float, { desc = 'LSP: Hover Diagnostic' })
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled(), { bufnr = 0 })
end, { desc = 'LSP: Toggle Diagnostics' })

-- delete bad defaults
if vim.fn.has('nvim-0.11') == 1 then
  pcall(vim.keymap.del, 'n', 'grr')
  pcall(vim.keymap.del, 'n', 'gri')
  pcall(vim.keymap.del, 'n', 'grn')
  pcall(vim.keymap.del, { 'n', 'x' }, 'grr')
  pcall(vim.keymap.del, { 'n', 'x' }, 'gra')
end
