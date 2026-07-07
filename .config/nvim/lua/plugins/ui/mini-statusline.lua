local statusline = require('mini.statusline')
statusline.setup({
  content = {
    active = function()
      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      mode = string.upper(mode)

      -- local diff = function()
      --   -- only show if present
      --   local summary = vim.b.minidiff_summary_string
      --   if summary == nil or summary == '' then
      --     return ''
      --   end
      --   return ' ' .. summary
      -- end

      local fileinfo = function()
        -- type
        local type = vim.bo.filetype
        if type ~= '' then
          type = require('mini.icons').get('filetype', type) .. ' ' .. type
        end

        -- size
        local fsize = math.max(vim.fn.line2byte(vim.fn.line('$') + 1) - 1, 0)
        local size = nil
        if fsize < 1024 then
          size = string.format('%dB', fsize)
        elseif fsize < 1048576 then
          size = string.format('%.2fKB', fsize / 1024)
        else
          size = string.format('%.2fMB', fsize / 1048576)
        end

        -- encoding
        local encoding = vim.bo.fileencoding or vim.bo.encoding
        local format = vim.bo.fileformat

        return string.format('%s %s[%s] %s', type, encoding, format, size)
      end

      local progress = function()
        local cur = vim.fn.line('.')
        local total = vim.fn.line('$')
        if cur == 1 then
          return 'TOP'
        elseif cur == total then
          return 'BOT'
        else
          return string.format('%2d%%%%', math.floor(cur / total * 100))
        end
      end

      local lines = string.format('%dL', vim.fn.line('$'))

      -- return statusline.combine_groups({
      --   { hl = mode_hl, strings = { mode } },
      --   {
      --     hl = 'MiniStatuslineDevinfo',
      --     strings = {
      --       statusline.section_git({ trunc_width = 40 }),
      --       -- diff(),
      --       statusline.section_diagnostics({ trunc_width = 75 }),
      --     },
      --   },
      --   '%<', -- Mark general truncate point
      --   { hl = 'MiniStatuslineFilename', strings = { statusline.section_filename({ trunc_width = 140 }) } },
      --   '%=', -- End left alignment
      --   { hl = 'MiniStatuslineFilename', strings = { file_size() } },
      --   { hl = 'MiniStatuslineFileinfo', strings = { filetype() } },
      --   { hl = 'MiniStatuslineModeNormal', strings = { progress() .. ' / ' .. lines } },
      --   { strings = { filetype(), file_size(), progress(), lines } },
      -- })

      return statusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        {
          hl = '',
          strings = {
            statusline.section_git({ trunc_width = 40 }),
            statusline.section_diagnostics({ trunc_width = 75 }),
            statusline.section_filename({ trunc_width = 140 }),
          },
        },
        '%<', -- Mark general truncate point
        '%=', -- End left alignment
        { hl = 'NonText', strings = { fileinfo(), progress(), lines } },
      })
    end,
  },
})