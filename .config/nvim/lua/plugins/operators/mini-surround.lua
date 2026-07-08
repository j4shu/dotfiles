require('mini.surround').setup({
  custom_surroundings = {
    -- reverse defaults
    ['('] = { output = { left = '(', right = ')' } },
    ['['] = { output = { left = '[', right = ']' } },
    ['{'] = { output = { left = '{', right = '}' } },
    ['<'] = { output = { left = '<', right = '>' } },
    -- lua function
    f = { output = { left = 'function() ', right = ' end' } },
  },
  mappings = {
    add = 'sS',
    -- delete = 'sd',
    -- find = 'sf',
    -- find_left = 'sF',
    -- highlight = 'sh',
    -- replace = 'sr',

    update_n_lines = '',
    suffix_last = '',
    suffix_next = '',
  },
  n_lines = 200,
  respect_selection_type = true,
})

vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
vim.keymap.set('n', 'sA', 'sS_', { remap = true, desc = 'Add surrounding (New Lines)' })
