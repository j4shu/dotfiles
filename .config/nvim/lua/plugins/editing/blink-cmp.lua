local cmp = require('blink.cmp')
cmp.build():pwait()
cmp.setup({
  keymap = {
    preset = 'enter',
  },
  cmdline = {
    keymap = {
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Right>'] = {},
      ['<Left>'] = {},
    },
    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      menu = { auto_show = true },
    },
  },
  completion = {
    list = {
      selection = {
        preselect = false,
        auto_insert = false,
      },
    },
    menu = {
      -- auto_show = false,
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
  sources = {
    default = { 'lsp', 'path', 'buffer' },
  },
  signature = { enabled = false },
})
