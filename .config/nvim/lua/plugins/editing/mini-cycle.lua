require('mini.cycle').setup({
  cycles = {
    { variants = { 'true', 'false' } },
    { variants = { 'True', 'False' } },
    { variants = { '&&', '||' } },
    { variants = { 'and', 'or' } },
    { variants = { '==', '!=' } },
    { variants = { '<', '<=', '==', '>=', '>' } },
    { variants = { 'if', 'elif', 'else' } },
  },
  mappings = {
    next = '=',
    prev = '-',
  },
})
