vim.pack.add({
  { src = 'https://codeberg.org/cryptomilk/nvim-pack-ui.git' },
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  -- { src = 'https://github.com/nvim-mini/mini.nvim' },
  -- { src = 'https://github.com/j4shu/mini.nvim' },
  { src = 'https://github.com/j4shu/mini.nvim', version = 'feat/extra-smart-picker' },
  -- lsp
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/saghen/blink.lib' },
  -- ui
  { src = 'https://github.com/utilyre/sentiment.nvim' },
  -- editing
  { src = 'https://github.com/numToStr/Comment.nvim' },
  { src = 'https://github.com/nmac427/guess-indent.nvim' },
  { src = 'https://github.com/zbirenbaum/copilot.lua' },
})
vim.keymap.set('n', '<leader>p', '<cmd>Pack<CR>', { desc = 'vim.pack' })
vim.keymap.set('n', '<leader>U', function()
  vim.pack.update(nil, { target = 'Update (To Lockfile)' })
end, { desc = 'Lockfile' })
-- vim.keymap.set('n', '<leader>pe', function()
--   vim.cmd('edit' .. vim.fn.stdpath('config') .. '/nvim-pack-lock.json')
-- end, { desc = 'Lockfile' })

require('plugins.catppuccin')
vim.cmd.colorscheme('catppuccin')
vim.cmd('runtime! lua/plugins/editing/*')
vim.cmd('runtime! lua/plugins/lsp/*')
vim.cmd('runtime! lua/plugins/operators/*')
vim.cmd('runtime! lua/plugins/ui/*')
