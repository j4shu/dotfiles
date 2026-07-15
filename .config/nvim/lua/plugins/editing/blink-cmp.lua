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
        preselect = true,
        auto_insert = false,
      },
    },
    menu = {
      -- auto_show = false,
      max_height = 5,
      border = 'none',
    },
    documentation = { auto_show = false },
  },
  signature = { enabled = false },
})
