require('mention').setup({
  mappings = {
    append = '<leader>y',
    toggle = '<leader>m',
    close = '<Esc>',
  },
  window = {
    width = 0.7,
    height = 0.5,
    border = 'single',
  },
  auto_open = true,
})
