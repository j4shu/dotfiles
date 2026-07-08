-- clipboard
if vim.env.SSH_CLIENT ~= nil then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = function()
        return nil
      end,
      ['*'] = function()
        return nil
      end,
    },
  }
end
vim.o.clipboard = 'unnamedplus'

-- misc
vim.o.undofile = true
vim.o.swapfile = false
vim.o.confirm = true
vim.o.virtualedit = 'block'
vim.o.scrolloff = 12

-- ui
vim.o.cursorline = true
vim.o.winborder = 'single'

-- fold
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevelstart = 99

-- tabs/indents
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- wrap
vim.o.breakindent = true
vim.o.linebreak = true
vim.o.wrap = false
vim.o.sidescrolloff = 8

-- chars
vim.o.list = true
vim.opt.listchars:append({
  tab = '> ',
  trail = ' ',
  extends = '…',
  precedes = '…',
  nbsp = '␣',
})
vim.opt.fillchars:append({
  diff = '╱',
  fold = ' ',
  foldsep = ' ',
  foldopen = '',
  foldclose = '',
})

-- statusline
vim.o.laststatus = 3
vim.o.showmode = false
vim.o.showcmd = false

-- statuscolumn
vim.o.number = true
vim.o.signcolumn = 'yes'

-- splits
vim.o.splitbelow = true
vim.o.splitright = true

-- search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrapscan = false
vim.o.incsearch = false

-- mouse
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:1,hor:1'
