vim.keymap.set('n', '<leader>mu', vim.pack.update, { desc = 'Update' })
vim.keymap.set('n', '<leader>mU', function()
  vim.pack.update(nil, { offline = true })
end, { desc = 'Update (Offline)' })
vim.keymap.set('n', '<leader>ml', function()
  vim.pack.update(nil, { target = 'lockfile' })
end, { desc = 'Update (To Lockfile)' })
vim.keymap.set('n', '<leader>mx', function()
  local name = vim.fn.input('Plugin name: ')
  if name ~= '' then
    vim.pack.del({ name })
  end
end, { desc = 'Delete' })

vim.keymap.set('n', '<leader>me', function()
  vim.cmd('edit' .. vim.fn.stdpath('config') .. '/nvim-pack-lock.json')
end, { desc = 'Lockfile' })

vim.pack.add({
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  -- lsp
  { src = 'https://github.com/folke/lazydev.nvim' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' },
  -- cmp
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/saghen/blink.cmp', version = 'v1.7.0' },
  { src = 'https://github.com/zbirenbaum/copilot.lua' },
  -- ui
  { src = 'https://github.com/utilyre/sentiment.nvim' },
  { src = 'https://github.com/BranimirE/fix-auto-scroll.nvim' },
  { src = 'https://github.com/saghen/blink.indent' },
  { src = 'https://github.com/rachartier/tiny-cmdline.nvim' },
  -- editing
  { src = 'https://github.com/folke/snacks.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'master' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
  { src = 'https://github.com/numToStr/Comment.nvim' },
  { src = 'https://github.com/nmac427/guess-indent.nvim' },
  { src = 'https://github.com/alexghergh/nvim-tmux-navigation' },
  { src = 'https://github.com/monaqa/dial.nvim' },
})
require('plugins.catppuccin')
vim.cmd.colorscheme('catppuccin')
vim.cmd('runtime! lua/plugins/lsp/*')
vim.cmd('runtime! lua/plugins/cmp/*')
vim.cmd('runtime! lua/plugins/ui/*')
vim.cmd('runtime! lua/plugins/editing/*')
vim.cmd('runtime! lua/plugins/operators/*')
vim.cmd('runtime! lua/plugins/git/*')
