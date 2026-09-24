vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set
map('n', '<esc>', function()
  vim.cmd('nohlsearch')
  vim.cmd('echon')
end)

-- for C-o and C-i to work
map('n', '<C-i>', '<C-i>')

-- leader
map('n', '<leader>w', '<cmd>update<CR>', { desc = 'Write' })
map('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })
map('n', '<leader>d', '<cmd>bd!<CR>', { desc = 'Buffer: Delete' })
map('n', '<leader>Q', '<cmd>qa!<CR>', { desc = 'Quit (All)' })
map('n', '<leader>M', '<cmd>messages<CR>', { desc = 'Messages' })
map('n', '<leader>R', '<cmd>restart<CR>', { desc = 'Restart' })

-- append
map('n', '<leader>,', 'mzA,<Esc>`z', { desc = 'Append Comma' })
map('n', '<leader>;', 'mzA;<Esc>`z', { desc = 'Append Semicolon' })

-- toggles
map('n', '<leader>tw', function()
  local wrap = not vim.wo.wrap
  vim.wo.wrap = wrap
  vim.notify('Toggled: Word Wrap ' .. (wrap and 'On' or 'Off'))
end, { desc = 'Toggle Word Wrap' })

-- movement
map({ 'n', 'x' }, 'j', function()
  return vim.v.count > 0 and 'j' or 'gj'
end, { expr = true })
map({ 'n', 'x' }, 'k', function()
  return vim.v.count > 0 and 'k' or 'gk'
end, { expr = true })
map({ 'n', 'x', 'o' }, 'E', 'g$')
-- smart 0/^ https://github.com/wscnd/LunarVim/blob/master/lua/keymappings.lua#L98
map({ 'n', 'x', 'o' }, '0', function()
  local line = vim.fn.getline('.')
  local col = vim.fn.col('.') - 1
  return line:sub(1, col):match('^%s+$') and '0' or '^'
end, { expr = true })

-- editing
map({ 'n', 'x' }, ';', ':')
map('n', 'O', 'o<Esc>')
map('n', '<CR>', '"_ciw')
map('n', 'U', '<C-r>')
map('n', '<BS>', '<C-^>')
map('n', 'i', function()
  return vim.fn.getline('.') == '' and '"_cc' or 'i'
end, { expr = true })
map('n', 'X', 'mzA<BS><Esc>`z')
map('n', 'gX', function()
  os.execute('open -R ' .. vim.api.nvim_buf_get_name(0))
end, { desc = 'Reveal in Finder' })
map('n', '<leader><C-c>', 'gcgc', { remap = true, desc = 'Uncomment' })

-- visual
map('x', 'p', 'P', { remap = true })
map('x', '<CR>', '"_c')
map('x', 'I', function()
  return vim.fn.mode() == 'V' and '0<C-v>I' or 'I'
end, { expr = true })
map('x', 'A', function()
  return vim.fn.mode() == 'V' and '$<C-v>A' or 'A'
end, { expr = true })

-- preserve clipboard
map({ 'n', 'x' }, 'x', '"_x')
map({ 'n', 'x' }, 'c', '"_c')
map({ 'n', 'x' }, 'C', '"_C')
map('n', 'dd', function()
  return vim.api.nvim_get_current_line():match('^%s*$') and '"_dd' or 'dd'
end, { expr = true })

-- search
map('n', '*', '*``')
map('x', '*', '"zy' .. '/<C-r>z<CR>``')

-- custom operators
-- https://old.reddit.com/r/neovim/comments/1dfvluw/share_your_favorite_settingsfeaturesexcerpts_from/l8qlbs8/
-- https://github.com/neovim/neovim/issues/21676
-- https://vim.fandom.com/wiki/Search_and_replace
map('n', 'sw', 'yiw' .. '*``' .. '"_cgn', { desc = 'Substitute cword (Instance)' })
map('x', 'sw', 'y' .. '/<C-r>0<CR>``' .. '_cgn', { desc = 'Substitute (Instance)' })

-- comments
-- Sticky toggle on top of built-in gc/gcc
local function restore_cursor(pos)
  local last = vim.api.nvim_buf_line_count(0)
  local row = math.max(1, math.min(pos[1], last))
  local col = math.max(0, math.min(pos[2], #vim.fn.getline(row)))
  pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
end
map('n', '<C-c>', function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal ' .. vim.v.count1 .. 'gcc')
  restore_cursor(pos)
end)
map('x', '<C-c>', function()
  local pos = vim.api.nvim_win_get_cursor(0) -- active end of selection
  vim.cmd('normal! \27') -- leave visual so '<,'> are set
  local from = vim.api.nvim_buf_get_mark(0, '<')[1]
  local to = vim.api.nvim_buf_get_mark(0, '>')[1]
  vim.cmd(('normal %dGV%dGgc'):format(from, to)) -- reselect the lines, toggle
  restore_cursor(pos)
end)

-- copy paths
map('n', 'yp', function()
  -- absolute
  local path = vim.fn.expand('%:p:~')
  vim.fn.setreg('+', path)
  vim.notify('Copied: ' .. path)
end)
map('n', 'yP', function()
  -- relative
  local path = vim.fn.expand('%:.')
  vim.fn.setreg('+', path)
  vim.notify('Copied: ' .. path)
end)
map('n', 'yt', function()
  -- tail
  local path = vim.fn.expand('%:t')
  vim.fn.setreg('+', path)
  vim.notify('Copied: ' .. path)
end)
map('n', 'yT', function()
  -- tail without extension
  local path = vim.fn.expand('%:t:r')
  vim.fn.setreg('+', path)
  vim.notify('Copied: ' .. path)
end)

-- windows
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
map('n', '<C-v>', '<C-w>v')
map('n', '<C-s>', '<C-w>s')

-- insert/command
map({ 'i', 'c' }, '<C-h>', '<Left>')
map({ 'i', 'c' }, '<C-l>', '<Right>')
map({ 'i', 'c' }, '<C-k>', '<Up>')
map({ 'i', 'c' }, '<C-j>', '<Down>')
map({ 'i', 'c' }, '<C-a>', '<Home>')
map({ 'i', 'c' }, '<C-e>', '<End>')
map({ 'i', 'c' }, '<C-d>', '<Del>')

-- undo points
for _, key in ipairs({ ',', '.', '!', '?', ':', ';' }) do
  map('i', key, key .. '<C-g>u')
end

-- undotree
vim.cmd('packadd nvim.undotree')
map('n', '<leader>u', function()
  require('undotree').open()
end, { desc = 'Undotree' })

-- incremental selection
vim.keymap.set({ 'n', 'x', 'o' }, 'm', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    vim.treesitter.select('parent', vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = 'Treesitter: Increase Selection' })

vim.keymap.set({ 'n', 'x', 'o' }, 'M', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    vim.treesitter.select('child', vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = 'Treesitter: Decrease Selection' })
