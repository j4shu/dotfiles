vim.filetype.add({
  extension = {
    zsh = 'sh',
    -- work
    suite = 'yaml',
    thpl = 'perl',
    cnf = 'json',
  },
  filename = {
    ['.zshrc'] = 'sh',
    ['.zshenv'] = 'sh',
  },
})

require('config.options')
require('config.autocommands')
require('config.keymaps')
require('pack')