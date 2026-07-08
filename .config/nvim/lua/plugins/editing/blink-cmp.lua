local cmp = require('blink.cmp')
cmp.build():pwait()
cmp.setup({
  cmdline = {
    keymap = {
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Right>'] = {},
      ['<Left>'] = {},
    },
    completion = {
      menu = { auto_show = true },
    },
  },
  completion = {
    menu = {
      max_height = 5,
      border = 'none',
      draw = {
        columns = {
          { 'label', 'label_description', gap = 1 },
          { 'kind_icon', 'kind' },
        },
      },
    },
    documentation = { auto_show = false },
    ghost_text = { enabled = false },
  },
  signature = { enabled = false },
})
