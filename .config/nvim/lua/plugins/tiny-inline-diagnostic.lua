vim.diagnostic.config({
  virtual_text = false,
  signs = false,
  severity_sort = true,
  jump = { wrap = false, float = true },
})

require('tiny-inline-diagnostic').setup({
  preset = 'classic',
  options = {
    show_source = {
      enabled = true,
    },
    throttle = 0,
    multilines = {
      enabled = true,
      always_show = true,
    },
  },
  signs = {
    diag = ' ',
  },
  blend = {
    factor = 0.4,
  },
})
