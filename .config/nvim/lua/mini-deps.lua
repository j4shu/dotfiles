local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(mini_path) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path })
end

local deps = require('mini.deps')
local add, now, later = deps.add, deps.now, deps.later
deps.setup({ path = { package = path_package } })
vim.keymap.set('n', '<leader>mu', function()
  deps.update()
  vim.cmd('norm! zj')
end, { desc = 'Update' })
vim.keymap.set('n', '<leader>mx', deps.clean, { desc = 'Clean' })
vim.keymap.set('n', '<leader>ml', '<cmd>DepsShowLog<cr><cmd>norm! G<cr>', { desc = 'Log' })
vim.keymap.set('n', '<leader>me', function()
  vim.cmd('edit' .. deps.config.path.snapshot)
end, { desc = 'Snapshot (Open)' })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'minideps-confirm' },
  callback = function(event)
    vim.wo.foldlevel = 0
    vim.keymap.set('n', '<leader>w', function()
      vim.cmd('write')
      deps.snap_save()
    end, { buffer = event.buf })
  end,
})

now(function()
  add({ source = 'catppuccin/nvim', name = 'catppuccin' })
  require('plugins.catppuccin')
  vim.cmd.colorscheme('catppuccin')
end)

later(function()
  -- lsp
  add('neovim/nvim-lspconfig')
  add('folke/lazydev.nvim')
  add('stevearc/conform.nvim')
  add('rachartier/tiny-inline-diagnostic.nvim')
  vim.cmd('runtime! lua/plugins/lsp/*')

  -- cmp
  add('windwp/nvim-autopairs')
  add({ source = 'saghen/blink.cmp', checkout = 'v1.7.0' })
  -- add('zbirenbaum/copilot.lua')
  -- add({
  -- source = 'CopilotC-Nvim/CopilotChat.nvim',
  -- depends = { 'nvim-lua/plenary.nvim' },
  -- })
  vim.cmd('runtime! lua/plugins/cmp/*')

  -- snacks
  add('folke/snacks.nvim')
  require('plugins.snacks')

  -- ui
  add('utilyre/sentiment.nvim')
  add('BranimirE/fix-auto-scroll.nvim')
  add('saghen/blink.indent')
  vim.cmd('runtime! lua/plugins/ui/*')

  -- editing
  add('nvim-treesitter/nvim-treesitter')
  add('nvim-treesitter/nvim-treesitter-context')
  add('numToStr/Comment.nvim')
  add('nmac427/guess-indent.nvim')
  add('alexghergh/nvim-tmux-navigation')
  add('monaqa/dial.nvim')
  vim.cmd('runtime! lua/plugins/editing/*')

  -- operators
  vim.cmd('runtime! lua/plugins/operators/*')

  -- git
  vim.cmd('runtime! lua/plugins/git/*')
end)
