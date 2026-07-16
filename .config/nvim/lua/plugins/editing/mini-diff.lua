local diff = require('mini.diff')
diff.setup({
  view = { style = 'sign' },
})

vim.keymap.set('n', '<leader>gd', diff.toggle_overlay, { desc = 'Git: Toggle Diff' })

-- reset hunks
vim.keymap.set('n', '<leader>gr', 'gHgh', { desc = 'Git: Reset Hunk', remap = true })
vim.keymap.set('x', '<leader>gr', 'gH', { desc = 'Git: Reset Hunk (Visual)', remap = true })
vim.keymap.set('n', '<leader>gR', function()
  diff.do_hunks(0, 'reset')
end, { desc = 'Git: Reset Hunk (Buffer)' })
