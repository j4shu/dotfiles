require('mention').setup({
  mappings = {
    append = '<leader>y',
    toggle = '<leader>m',
    close = '<Esc>',
  },
  window = {
    width = 0.7,
    height = 0.5,
    border = 'single',
  },
  auto_open = true,

  -- Pi reads files when told to,
  format = function(path, from, to)
    path = vim.fn.fnamemodify(path, ':~')
    if not from then
      return 'read ' .. path
    end
    local range = from == to and ('line ' .. from) or ('lines ' .. from .. '-' .. to)
    return ('read %s, %s'):format(path, range)
  end,
})
