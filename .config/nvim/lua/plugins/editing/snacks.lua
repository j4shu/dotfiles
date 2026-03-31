local snacks = require('snacks')

-- git
vim.keymap.set({ 'n', 'x' }, '<leader>gy', function()
  snacks.gitbrowse({
    open = function(url)
      vim.fn.setreg(vim.v.register, url)
    end,
    remote_patterns = {
      -- https://github.com/jshu-git/dotfiles.git/blob/main/.config/nvim/lua/plugins/git/snacks.lua#L21-L21
      { '^https://github.com/(.*).git', 'https://github.com/%1' },

      -- (https://bitbucket.ngage.netapp.com)/scm/(op)/(api).git -> (https://bitbucket.ngage.netapp.com)/projects/(op)/repos/(api)/browse
      { '^(https://bitbucket%.ngage%.netapp%.com)/scm/(.*)/(.*).git$', '%1/projects/%2/repos/%3/browse' },
    },
    url_patterns = {
      ['bitbucket.ngage.netapp.com'] = {
        file = '/{file}#{line_start}-{line_end}',
      },
    },
  })
end, { desc = 'Git: Yank URL' })

vim.keymap.set({ 'n', 'x' }, '<leader>gb', function()
  snacks.git.blame_line({
    win = {
      width = 0.9,
      height = 0.9,
      keys = { ['<Esc>'] = 'close' },
    },
  })
end, { desc = 'Git: Blame' })

-- snacks.picker.util.truncpath = function(path, _, opts)
--   local cwd = svim.fs.normalize(opts and opts.cwd or vim.fn.getcwd(), { _fast = true, expand_env = false })
--   path = svim.fs.normalize(path, { _fast = true, expand_env = false })
--   if path:find(cwd .. '/', 1, true) == 1 and #path > #cwd then
--     return path:sub(#cwd + 2)
--   else
--     local home = svim.fs.normalize('~')
--     return '~' .. path:sub(#home + 1)
--   end
-- end

snacks.setup({
  picker = {
    prompt = '',
    show_delay = 100,
    matcher = {
      cwd_bonus = true,
      frecency = true,
    },
    previewers = {
      diff = {
        style = 'terminal',
      },
    },
    sources = {
      smart = {
        matcher = { sort_empty = false },
        hidden = vim.env.SSH_CLIENT == nil,
        -- follow = true

        -- filter=false needed for ~/.local/share/nvim files to show
        -- for work, mounts cause slowness
        filter = vim.env.SSH_CLIENT and { cwd = vim.env.HOME } or false,
      },
      grep = { hidden = vim.env.SSH_CLIENT == nil },
    },
    layout = { preset = 'default' },
    layouts = {
      default = {
        hidden = { 'preview' },
        layout = {
          backdrop = false,
          width = 0.9,
          height = 0.9,
        },
      },
    },
    win = {
      input = {
        keys = {
          ['<Esc>'] = { 'close', mode = { 'i', 'n' } },
          ['<Tab>'] = { 'toggle_preview', mode = { 'i', 'n' } },
          ['<Down>'] = { 'history_forward', mode = { 'i', 'n' } },
          ['<Up>'] = { 'history_back', mode = { 'i', 'n' } },
          ['<C-x>'] = { 'select_and_next', mode = { 'i', 'n' } },
          ['<C-j>'] = { 'focus_list', mode = { 'i', 'n' } },
          ['<C-a>'] = false,
          ['<S-Tab>'] = false,

          -- custom scrolling
          ['<C-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
          ['<C-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
          ['<C-h>'] = { 'preview_scroll_left', mode = { 'i', 'n' } },
          ['<C-l>'] = { 'preview_scroll_right', mode = { 'i', 'n' } },
        },
      },
    },
    actions = {
      preview_scroll_down = function(picker)
        if picker.preview.win:valid() then
          picker.preview.win:scroll()
        else
          picker.list:scroll(picker.list.state.scroll)
        end
      end,
      preview_scroll_up = function(picker)
        if picker.preview.win:valid() then
          picker.preview.win:scroll(true)
        else
          picker.list:scroll(-picker.list.state.scroll)
        end
      end,
      preview_scroll_left = function(picker)
        if picker.preview.win:valid() then
          picker.preview.win:hscroll(true)
        else
          picker.list.win:hscroll(true)
        end
      end,
      preview_scroll_right = function(picker)
        if picker.preview.win:valid() then
          picker.preview.win:hscroll()
        else
          picker.list.win:hscroll()
        end
      end,
    },
  },
})

-- picker
local picker = snacks.picker

-- files
vim.keymap.set('n', '<Tab>', picker.smart, { desc = 'Files (Smart)' })
vim.keymap.set('n', '<leader><Tab>', function()
  picker.smart({ cwd = vim.fn.expand('%:p:h') })
end, { desc = 'Files (Smart) (Relative)' })

-- grep
vim.keymap.set('n', '<leader>fw', picker.grep, { desc = 'Grep Live' })
vim.keymap.set('n', '<leader>fW', function()
  picker.grep({ cwd = vim.fn.expand('%:p:h') })
end, { desc = 'Grep Live (Relative)' })
vim.keymap.set('n', '<leader>*', picker.grep_word, { desc = 'Grep cword' })
vim.keymap.set('n', '<leader>#', function()
  picker.grep_word({ cwd = vim.fn.expand('%:p:h') })
end, { desc = 'Grep cword (Relative)' })
vim.keymap.set('x', '<leader>fw', picker.grep_word, { desc = 'Grep' })
vim.keymap.set('x', '<leader>fW', function()
  picker.grep_word({ cwd = vim.fn.expand('%:p:h') })
end, { desc = 'Grep (Relative)' })

-- lsp
vim.keymap.set('n', 'gd', function()
  picker.lsp_definitions({ auto_confirm = false })
end, { desc = 'LSP: Goto Definition' })
vim.keymap.set('n', 'gr', function()
  picker.lsp_references({ auto_confirm = false })
end, { desc = 'LSP: Goto References' })
vim.keymap.set('n', '<leader>fd', picker.diagnostics_buffer, { desc = 'LSP: Diagnostics (Buffer)' })
vim.keymap.set('n', '<leader>fD', picker.diagnostics, { desc = 'LSP: Diagnostics' })

-- misc
vim.keymap.set('n', ',', function()
  picker.lines({
    layout = {
      preview = false,
      preset = 'select',
    },
    -- confirm = function(picker, _)
    --   local pattern = picker.finder.filter.pattern
    --   if pattern ~= '' then
    --     vim.fn.setreg('/', pattern)
    --   end
    --   picker:close()
    -- end,
  })
end)
vim.keymap.set('n', "'", picker.resume)
vim.keymap.set('n', '<leader>u', picker.undo, { desc = 'Undo Tree' })
vim.keymap.set('n', '<leader>fi', function()
  picker.icons({
    layout = { preset = 'default' },
    confirm = { action = { 'yank', 'close' } },
  })
end, { desc = 'Icons' })

-- git
vim.keymap.set({ 'n', 'x' }, '<leader>gl', picker.git_log_line, { desc = 'Git: Log (Line)' })
vim.keymap.set('n', '<leader>gL', picker.git_log_file, { desc = 'Git: Log (File)' })
vim.keymap.set('n', '<leader>gh', picker.git_diff, { desc = 'Git: Hunks' })

-- vim
vim.keymap.set('n', '<leader>fl', function()
  picker.highlights({
    confirm = { action = { 'yank', 'close' } },
  })
end, { desc = 'Highlights' })
vim.keymap.set('n', '<leader>fh', picker.help, { desc = 'Help' })
vim.keymap.set('n', '<leader>fc', picker.commands, { desc = 'Commands' })
vim.keymap.set('n', '<leader>fC', picker.pickers, { desc = 'Pickers' })
vim.keymap.set('n', '<leader>fk', picker.keymaps, { desc = 'Keymaps' })

-- vim.keymap.set('n', '<leader>ft', picker.colorschemes, { desc = 'Colorschemes' })
-- vim.keymap.set('n', '<leader>fa', picker.autocmds, { desc = 'Autocommands' })
-- vim.keymap.set('n', '<leader>"', picker.registers, { desc = 'Registers' })
-- vim.keymap.set('n', '<leader>:', function()
--   picker.command_history({ layout = { preset = 'default' } })
-- end, { desc = 'Command History' })
-- vim.keymap.set('n', '<leader>/', function()
--   picker.search_history({ layout = { preset = 'default' } })
-- end, { desc = 'Search History' })
