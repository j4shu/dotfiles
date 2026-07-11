local render_markdown = require('render-markdown')
render_markdown.setup({
  sign = { enabled = false },
  file_types = { 'markdown' },
})

vim.keymap.set('n', '<leader>tm', function()
  render_markdown.toggle()
  vim.notify('Toggled: Markdown Preview ' .. (render_markdown.get() and 'On' or 'Off'))
end, { desc = 'Toggle Markdown Preview' })
