-- yank highlight
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.hl_op()
  end,
})

-- disable auto comments
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function(args)
    -- Defer past the built-in ftplugin, which re-adds r/o via `formatoptions+=croql`.
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        vim.bo[args.buf].formatoptions = vim.bo[args.buf].formatoptions:gsub('[ro]', '')
      end
    end)
  end,
})

-- word wrap for prose-like filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text' },
  callback = function()
    vim.wo.wrap = true
    vim.wo.spell = true
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
