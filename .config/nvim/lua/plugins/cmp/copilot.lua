require('copilot').setup({
  panel = {
    auto_refresh = true,
    layout = {
      position = 'right',
      width = 30,
    },
  },
  suggestion = {
    auto_trigger = true,
    hide_during_completion = false,
    debounce = 0,
    keymap = {
      accept = false,
      accept_word = '<A-l>',
      next = '<A-n>',
      prev = '<A-p>',
    },
  },
  filetypes = {
    ['*'] = true,
  },
  -- lsp_binary = vim.env.SSH_CLIENT and '~/.packages/copilot-language-server' or nil,
})

local suggestion = require('copilot.suggestion')
-- https://github.com/zbirenbaum/copilot.lua/issues/91
vim.keymap.set('i', '<Tab>', function()
  if suggestion.is_visible() then
    suggestion.accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false)
  end
end)
vim.keymap.set('i', '<C-c>', function()
  if suggestion.is_visible() then
    suggestion.dismiss()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, false, true), 'n', false)
  end
end)

-- chat
-- local chat = require('CopilotChat')
-- chat.setup({
--   model = 'gpt-4',
--   show_help = false,
--   chat_autocomplete = false,
--   separator = '',
--   mappings = {
--     complete = {
--       insert = '',
--     },
--     close = {
--       normal = '<leader>q',
--       insert = '',
--     },
--     reset = {
--       normal = '<leader>c',
--       insert = '',
--     },
--     submit_prompt = {
--       normal = '<leader>w',
--       insert = '',
--     },
--     show_help = {
--       normal = 'g?',
--     },
--   },
-- })
--
-- vim.keymap.set({ 'n', 'x' }, '<leader>a', chat.toggle, { desc = 'CopilotChat' })
-- vim.api.nvim_create_autocmd('BufEnter', {
--   pattern = 'copilot-*',
--   callback = function()
--     vim.opt_local.conceallevel = 0
--   end,
-- })
