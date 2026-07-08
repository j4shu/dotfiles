require('copilot').setup({
  suggestion = {
    auto_trigger = true,
    hide_during_completion = false,
    keymap = {
      accept = '<Tab>',
      accept_word = '<A-l>',
      next = '<A-n>',
      prev = '<A-p>',
      dismiss = '<C-c>',
    },
  },
  filetypes = {
    ['*'] = true,
  },
})
