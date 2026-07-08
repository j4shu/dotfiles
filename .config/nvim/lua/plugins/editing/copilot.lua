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

-- toggle copilot
vim.g.enable_copilot = true
vim.keymap.set('n', '<leader>tc', function()
  suggestion.toggle_auto_trigger()
  vim.g.enable_copilot = not vim.g.enable_copilot
  vim.notify('Toggled: Copilot ' .. (vim.g.enable_copilot and 'On' or 'Off'))
end, { desc = 'Toggle Copilot' })
