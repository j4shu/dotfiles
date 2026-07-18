local jump2d = require('mini.jump2d')
jump2d.setup({
  spotter = jump2d.builtin_opts.word_start.spotter,
  view = {
    n_steps_ahead = 1,
  },
  allowed_lines = {
    blank = false,
  },
  mappings = {
    start_jumping = 'gw',
  },
  silent = true,
})
