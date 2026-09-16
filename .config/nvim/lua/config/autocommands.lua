local augroup = vim.api.nvim_create_augroup('config', { clear = true })

-- yank highlight
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- disable auto comments
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = '*',
  callback = function(args)
    -- Runs after the built-in ftplugin (registered earlier), so -=ro sticks.
    vim.bo[args.buf].formatoptions = vim.bo[args.buf].formatoptions:gsub('[ro]', '')
  end,
})

-- word wrap for prose-like filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = { 'markdown', 'text' },
  callback = function()
    vim.wo.spell = true
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup,
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})
