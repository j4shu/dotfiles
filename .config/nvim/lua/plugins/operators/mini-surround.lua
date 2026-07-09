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
    add = '', -- 'sa' is for substitute operators
  },
  n_lines = 200,
  respect_selection_type = true,
})
vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
