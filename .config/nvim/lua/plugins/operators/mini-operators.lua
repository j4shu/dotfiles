local operators = require('mini.operators')
operators.setup({
  evaluate = { prefix = 'se' },
  exchange = { prefix = 'sx' },
  multiply = { prefix = 'sm' },
  replace = { prefix = '' },
  sort = { prefix = 'so' },
})

operators.make_mappings('replace', {
  textobject = 's',
  line = 'ss',
  selection = 'ss',
})
vim.keymap.set('n', 'S', 's$', { remap = true })
vim.keymap.set('n', 'sE', 'se$', { remap = true, desc = 'Evaluate (EOL)' })

-- swap arguments
vim.keymap.set('n', 'sxl', 'sx' .. 'i' .. 'a' .. 'sx' .. 'in' .. 'a', { desc = 'Swap Argument Right', remap = true })
vim.keymap.set('n', 'sxh', 'sx' .. 'i' .. 'a' .. 'sx' .. 'il' .. 'a', { desc = 'Swap Argument Left', remap = true })
