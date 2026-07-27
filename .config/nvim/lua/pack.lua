vim.pack.add({
  { src = 'https://codeberg.org/cryptomilk/nvim-pack-ui.git' },
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  -- { src = 'https://github.com/nvim-mini/mini.nvim' },
  { src = 'https://github.com/j4shu/mini.nvim' },
  -- lsp
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/folke/lazydev.nvim' },
  { src = 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/saghen/blink.lib' },
  -- ui
  { src = 'https://github.com/utilyre/sentiment.nvim' },
  -- editing
  { src = 'https://github.com/nmac427/guess-indent.nvim' },
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/zbirenbaum/copilot.lua' },
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
  { src = 'https://github.com/j4shu/mention.nvim' },
})
vim.keymap.set('n', '<leader>p', '<cmd>Pack<CR>', { desc = 'vim.pack' })
vim.keymap.set('n', '<leader>U', function()
  vim.pack.update(nil, { target = 'Update (To Lockfile)' })
end, { desc = 'Lockfile' })

require('plugins.catppuccin')
vim.cmd.colorscheme('catppuccin')
vim.cmd('runtime! lua/plugins/editing/*.lua')
vim.cmd('runtime! lua/plugins/lsp/*.lua')
vim.cmd('runtime! lua/plugins/operators/*.lua')
vim.cmd('runtime! lua/plugins/ui/*.lua')
