local clue = require('mini.clue')
clue.setup({
  window = {
    delay = 250,
    config = function(bufnr)
      local max_width = 0
      for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
        max_width = math.max(max_width, vim.fn.strchars(line))
      end
      return {
        width = math.min(40, max_width),
        title_pos = 'center',
      }
    end,
  },
  triggers = {
    -- leader
    { mode = 'n', keys = '<leader>' },
    { mode = 'x', keys = '<leader>' },

    -- builtin completion
    { mode = 'i', keys = '<C-x>' },

    -- g
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- window
    { mode = 'n', keys = '<C-w>' },

    -- folds
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },

    -- unimpaired
    { mode = 'n', keys = ']' },
    { mode = 'n', keys = '[' },

    -- custom operators
    { mode = 'n', keys = 's' },
    { mode = 'x', keys = 's' },
  },
  clues = {
    -- clue.gen_clues.g(),
    -- clue.gen_clues.marks(),
    clue.gen_clues.builtin_completion(),
    clue.gen_clues.registers(),
    clue.gen_clues.windows(),
    clue.gen_clues.z(),

    -- leader
    { mode = 'n', keys = '<leader>f', desc = 'Find…' },
    { mode = 'x', keys = '<leader>f', desc = 'Find…' },
    { mode = 'n', keys = '<leader>t', desc = 'Toggle…' },
    { mode = 'n', keys = '<leader>g', desc = 'Git…' },
    { mode = 'x', keys = '<leader>g', desc = 'Git…' },
    { mode = 'n', keys = '<leader>n', desc = 'Notifications…' },
    { mode = 'n', keys = '<leader>m', desc = 'Plugins' },
    { mode = 'n', keys = '<leader>l', desc = 'LSP…' },

    -- submodes
    -- buffers
    -- { mode = 'n', keys = '<leader><Tab>', postkeys = '<leader>' },
    -- { mode = 'n', keys = '<leader><S-Tab>', postkeys = '<leader>' },
    -- folds
    -- { mode = "n", keys = "zj", postkeys = "z" },
    -- { mode = "n", keys = "zk", postkeys = "z" },
    -- { mode = "n", keys = "z=", postkeys = "z" },
    -- { mode = "n", keys = "z-", postkeys = "z" },
    -- { mode = "n", keys = "zo", postkeys = "z" },
    -- { mode = "n", keys = "zc", postkeys = "z" },
  },
})
