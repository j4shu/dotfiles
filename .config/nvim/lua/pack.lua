vim.pack.add({
  { src = 'https://codeberg.org/cryptomilk/nvim-pack-ui.git' },
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  { src = 'https://github.com/nvim-mini/mini.nvim' },

  -- misc
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'master' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },

  -- ui
  { src = 'https://github.com/utilyre/sentiment.nvim' },
  { src = 'https://github.com/rachartier/tiny-cmdline.nvim' },
  { src = 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' },
  -- editing
  { src = 'https://github.com/numToStr/Comment.nvim' },
  { src = 'https://github.com/nmac427/guess-indent.nvim' },
  { src = 'https://github.com/windwp/nvim-autopairs' },
})

-- vim.pack
vim.keymap.set('n', '<leader>mm', '<cmd>Pack<CR>', { desc = 'vim.pack' })
vim.keymap.set('n', '<leader>me', function()
  vim.cmd('edit' .. vim.fn.stdpath('config') .. '/nvim-pack-lock.json')
end, { desc = 'Lockfile' })


require('plugins.catppuccin')
vim.cmd.colorscheme('catppuccin')
vim.cmd('runtime! lua/plugins/editing/*')
vim.cmd('runtime! lua/plugins/operators/*')
vim.cmd('runtime! lua/plugins/ui/*')
