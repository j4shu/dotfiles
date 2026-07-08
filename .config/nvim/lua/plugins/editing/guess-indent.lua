require('guess-indent').setup({})
vim.keymap.set('n', '<leader>G', '<cmd>GuessIndent<cr>', { desc = 'GuessIndent' })
