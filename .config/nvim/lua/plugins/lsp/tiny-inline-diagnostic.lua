vim.diagnostic.config({
  virtual_text = false,
  signs = false,
})

require('tiny-inline-diagnostic').setup({
  preset = 'classic',
  options = {
    show_source = {
      enabled = true,
    },
    multilines = {
      enabled = true,
      always_show = true,
    },
  },
  signs = {
    diag = ' ',
  },
})
