local pick = require('mini.pick')
local extras = require('mini.extra').pickers

pick.setup({
  mappings = {
    delete_left = '', -- defaults to <C-u>
    move_start = '', -- defaults to <C-g>

    choose_marked = '<C-q>',
    refine = '<C-g>',
    refine_marked = '<C-S-g>',
    scroll_down = '<C-d>',
    scroll_up = '<C-u>',
  },
  window = {
    config = {
      row = vim.o.lines - 1,
      height = math.floor(0.5 * vim.o.lines),
      width = math.floor(0.75 * vim.o.columns),
    },
  },
})

-- files
vim.keymap.set('n', '<Tab>', extras.smart, { desc = 'Files (Smart)' })
-- vim.keymap.set('n', '<Tab>', pick.builtin.buffers, { desc = 'Buffers' })
-- vim.keymap.set('n', '<Tab>', function()
--   pick.builtin.files({ tool = 'fd' })
-- end, { desc = 'Files' })
-- vim.keymap.set('n', '<leader>ff', function()
--   pick.builtin.files({ tool = 'fd' })
-- end, { desc = 'Files' })
-- vim.keymap.set('n', '<leader>fF', function()
--   pick.builtin.files({ tool = 'fd' }, { source = { cwd = vim.fn.expand('%:p:h') } })
-- end, { desc = 'Files (Relative)' })
-- vim.keymap.set('n', '<leader>fr', function()
--   extras.oldfiles({ tool = 'fd' })
-- end, { desc = 'Files (Recent)' })

-- grep (live)
vim.keymap.set('n', '<leader>fw', pick.builtin.grep_live, { desc = 'Grep Live' })
vim.keymap.set('n', '<leader>fW', function()
  pick.builtin.grep_live(nil, { source = { cwd = vim.fn.expand('%:p:h') } })
end, { desc = 'Grep Live (Relative)' })

-- grep
-- vim.keymap.set("n", "<leader>*", function()
-- 	local input = vim.fn.input("Grep (cwd): ", vim.fn.expand("<cword>"))
-- 	if input ~= "" then
-- 		pick.builtin.grep({ pattern = input }, { source = { name = "Grep: " .. input } })
-- 	end
-- end, { desc = "Grep" })
-- vim.keymap.set("n", "<leader>#", function()
-- 	local input = vim.fn.input("Grep (Relative): ", vim.fn.expand("<cword>"))
-- 	if input ~= "" then
-- 		pick.builtin.grep({ pattern = input }, { source = { name = "Grep: " .. input, cwd = vim.fn.expand("%:p:h") } })
-- 	end
-- end, { desc = "Grep (Relative)" })

-- grep (visual)
-- vim.keymap.set("x", "<leader>fw", function()
-- 	local selection = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
-- 	pick.builtin.grep({ pattern = selection }, { source = { name = "Grep: " .. selection } })
-- end, { desc = "Grep" })
-- vim.keymap.set("x", "<leader>fW", function()
-- 	local selection = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
-- 	pick.builtin.grep({ pattern = selection }, { source = { name = selection, cwd = vim.fn.expand("%:p:h") } })
-- end, { desc = "Grep (Relative)" })

-- lsp
vim.keymap.set('n', 'gd', function()
  extras.lsp({ scope = 'definition' })
end, { desc = 'LSP: Goto Definition' })
vim.keymap.set('n', 'gr', function()
  extras.lsp({ scope = 'references' })
end, { desc = 'LSP: Goto References' })
-- vim.keymap.set('n', '<leader>fd', function()
--   extras.diagnostic({ scope = 'current' })
-- end, { desc = 'LSP: Diagnostics (Buffer)' })
-- vim.keymap.set('n', '<leader>fD', function()
--   extras.diagnostic({ scope = 'all' })
-- end, { desc = 'LSP: Diagnostics' })

-- misc
vim.keymap.set('n', ',', function()
  extras.buf_lines({ scope = 'current' }, {
    source = {
      choose = function(item)
        ---@diagnostic disable:param-type-mismatch
        local query = table.concat(pick.get_picker_query())
        if query ~= '' then
          vim.fn.setreg('/', query)
        end
        pick.default_choose(item)
      end,
    },
  })
end)
vim.keymap.set('n', "'", function()
  if not pcall(pick.builtin.resume) then
    vim.notify('[mini.pick] No picker to resume', vim.log.levels.WARN)
  end
end)

-- git
-- vim.keymap.set("n", "<leader>gl", function()
-- 	extras.git_commits({ path = vim.fn.expand("%") })
-- end, { desc = "Log (Buffer)" })
-- vim.keymap.set('n', '<leader>gL', extras.git_commits, { desc = 'Log' })
-- vim.keymap.set("n", "<leader>gh", extras.git_hunks, { desc = "Hunks" })

-- vim
vim.keymap.set('n', '<leader>fl', extras.hl_groups, { desc = 'Highlights' })
vim.keymap.set('n', '<leader>fk', extras.keymaps, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>fh', pick.builtin.help, { desc = 'Help' })
-- vim.keymap.set("n", "<leader>fo", extras.options, { desc = "Options" })
-- vim.keymap.set("n", "<leader>ft", extras.colorschemes, { desc = "Themes" })
-- vim.keymap.set("n", "<leader>fc", extras.commands, { desc = "Commands" })
-- vim.keymap.set('n', '<leader>fK', function()
--   extras.keymaps({ scope = 'buf' })
-- end, { desc = 'Keymaps (Buffer)' })
-- vim.keymap.set('n', '<leader>"', extras.registers, { desc = 'Registers' })
-- vim.keymap.set('n', '<leader>:', function()
--   extras.history({ scope = ':' })
-- end, { desc = 'Command History' })
-- vim.keymap.set('n', '<leader>/', function()
--   extras.history({ scope = '/' })
-- end, { desc = 'Search History' })
