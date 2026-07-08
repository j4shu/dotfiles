local trailspace = require('mini.trailspace')
trailspace.setup()
vim.keymap.set('n', '<leader>T', trailspace.trim, { desc = 'Trim Trailspace' })
