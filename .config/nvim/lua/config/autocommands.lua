-- yank highlight
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.hl_op()
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})
