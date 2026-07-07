local files = require('mini.files')
files.setup({
  mappings = {
    close = '<esc>',
    go_in = '',
    go_in_plus = '<CR>',
    go_out = '',
    go_out_plus = '-',
    synchronize = '<leader>w',
    reveal_cwd = '',
  },
  options = {
    permanent_delete = false,
  },
  windows = {
    width_focus = math.floor(0.15 * vim.o.columns),
    width_nofocus = math.floor(0.15 * vim.o.columns),
    width_preview = math.floor(0.30 * vim.o.columns),
  },
})

-- explorer
vim.keymap.set('n', '<leader>e', function()
  if not files.close() then
    files.open(vim.api.nvim_buf_get_name(0), false)
    files.reveal_cwd()
  end
end, { desc = 'Explorer' })
vim.keymap.set('n', '<leader>E', function()
  files.open(nil, false)
end, { desc = 'Explorer(cwd)' })
vim.keymap.set('n', "<leader>'", function()
  files.open(files.get_latest_path())
end, { desc = 'Explorer (Latest)' })

-- toggle preview
local show_preview = false
local toggle_preview = function()
  show_preview = not show_preview
  files.refresh({ windows = { preview = show_preview } })
end

-- open in split
local map_split = function(direction)
  local cur_target = files.get_explorer_state().target_window
  local new_target = vim.api.nvim_win_call(cur_target, function()
    vim.cmd(direction .. ' split')
    return vim.api.nvim_get_current_win()
  end)
  files.set_target_window(new_target)

  -- close explorer
  files.go_in({ close_on_file = true })
end

-- create mappings
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    local buf_id = args.data.buf_id

    -- splits
    vim.keymap.set('n', '<C-s>', function()
      map_split('horizontal')
    end, { buffer = buf_id })
    vim.keymap.set('n', '<C-v>', function()
      map_split('vertical')
    end, { buffer = buf_id })

    -- preview
    vim.keymap.set('n', '<Tab>', toggle_preview, { buffer = buf_id, desc = 'Toggle Preview' })

    -- yank path
    vim.keymap.set('n', 'yp', function()
      local path = files.get_fs_entry().path
      vim.fn.setreg(vim.v.register, path)
      vim.notify('Yanked: ' .. path)
    end, { buffer = buf_id, desc = 'Yank path' })

    -- open path
    vim.keymap.set('n', 'gX', function()
      os.execute('open -R ' .. files.get_fs_entry().path)
    end, { buffer = buf_id, desc = 'Reveal in Finder' })

    -- reset to first entry and reveal
    vim.keymap.set('n', '<BS>', function()
      files.reset()
      files.reveal_cwd()
    end, { buffer = buf_id, desc = 'Reset cwd' })
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesExplorerOpen',
  callback = function()
    files.set_bookmark('c', vim.fn.getcwd, { desc = 'cwd' })
    files.set_bookmark('t', vim.fn.stdpath('data') .. '/mini.files/trash', { desc = 'Trash' })
    files.set_bookmark('s', vim.fn.stdpath('data'), { desc = 'Share' })
    files.set_bookmark('h', '~/', { desc = 'Home' })
  end,
})

-- customize window
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesWindowOpen',
  callback = function(args)
    local win_id = args.data.win_id
    local config = vim.api.nvim_win_get_config(win_id)
    config.title_pos = 'center'
    vim.api.nvim_win_set_config(win_id, config)
  end,
})
