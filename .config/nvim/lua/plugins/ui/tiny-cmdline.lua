require('vim._core.ui2').enable({})
vim.o.cmdheight = 0

local tiny_cmdline = require('tiny-cmdline')
tiny_cmdline.setup({
  menu_col_offset = 0,
  -- on_reposition = tiny_cmdline.adapters.blink,
})
