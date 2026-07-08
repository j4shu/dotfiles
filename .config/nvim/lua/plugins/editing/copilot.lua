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

local suggestion = require('copilot.suggestion')
vim.keymap.set('n', '<leader>tc', function()
  suggestion.toggle_auto_trigger()
  vim.notify('Toggled: Copilot')
end, { desc = 'Toggle Copilot' })
