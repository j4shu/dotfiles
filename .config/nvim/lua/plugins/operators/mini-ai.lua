local ai = require('mini.ai')
local extra_ai = require('mini.extra').gen_ai_spec
ai.setup({
  n_lines = 500,
  custom_textobjects = {
    g = extra_ai.buffer(),
    l = extra_ai.line(),
    e = { -- Word with case
      {
        '%u[%l%d]+%f[^%l%d]',
        '%f[%S][%l%d]+%f[^%l%d]',
        '%f[%P][%l%d]+%f[^%l%d]',
        '^[%l%d]+%f[^%l%d]',
      },
      '^().*()$',
    },
  },
})

vim.keymap.set('n', '<S-CR>', 'ciq', { remap = true })
