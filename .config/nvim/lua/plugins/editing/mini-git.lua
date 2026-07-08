local git = require('mini.git')
git.setup()

vim.keymap.set({ 'n', 'x' }, '<leader>gs', function()
  git.show_at_cursor({ split = 'vertical' })
end, { desc = 'Git: Show' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'git',
  callback = function()
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.MiniGit.diff_foldexpr()'
    vim.wo.foldlevel = 2
    vim.wo.number = false
  end,
})

-- Use only HEAD name as summary string
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniGitUpdated',
  callback = function(data)
    local summary = vim.b[data.buf].minigit_summary
    vim.b[data.buf].minigit_summary_string = summary.head_name or ''
  end,
})
