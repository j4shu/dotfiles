local conform = require('conform')
conform.setup({
  formatters_by_ft = {
    python = { 'black' },
    sh = { 'shfmt' },
    toml = { 'tombi' },
    lua = { 'stylua' },
    json = { 'prettier' },
    markdown = { 'prettier' },
  },
  formatters = {
    prettier = {
      prepend_args = { '--ignore-path', '/dev/null', '--prose-wrap', 'always', '--print-width', '80' },
    },
  },
  -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
  format_on_save = function()
    if vim.g.enable_autoformat then
      return {
        timeout_ms = 3000,
        lsp_format = 'fallback',
        quiet = true,
      }
    end
  end,
})

-- toggle autoformatting
vim.g.enable_autoformat = true
vim.keymap.set('n', '<leader>tf', function()
  vim.g.enable_autoformat = not vim.g.enable_autoformat
  vim.notify('Toggled: Autoformatting ' .. (vim.g.enable_autoformat and 'On' or 'Off'))
end, { desc = 'Toggle Autoformatting' })

-- save without formatting
vim.keymap.set('n', '<leader>W', function()
  vim.g.enable_autoformat = false
  vim.cmd.write()
  vim.g.enable_autoformat = true
end, { desc = 'Write (No Autoformat)' })
