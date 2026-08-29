local extra = require('mini.extra')
extra.setup()

-- Smart files picker: open buffers (MRU) > readable `v:oldfiles` > files in cwd.
-- Each path shown once, current file suppressed. Tiers 1-2 immediate, tier 3 on
-- tool exit. Empty query keeps tier order; typing uses default fuzzy matching.
extra.pickers.smart = function(local_opts, opts)
  local pick = require('mini.pick')
  local_opts = local_opts or {}

  local commands = {
    fd = { 'fd', '--type=f', '--color=never' },
    rg = { 'rg', '--files', '--color=never' },
  }
  local tool = local_opts.tool
  if tool == nil then
    tool = vim.fn.executable('fd') == 1 and 'fd' or (vim.fn.executable('rg') == 1 and 'rg' or nil)
    if tool == nil then
      error('(smart picker) needs an executable "fd" or "rg".', 0)
    end
  end
  local command = commands[tool]
  if command == nil then
    error('(smart picker) `local_opts.tool` should be one of "fd", "rg".', 0)
  end

  local full_path = function(path)
    return (vim.fn.fnamemodify(path, ':p'):gsub('(.)/$', '%1'))
  end
  local short_path = function(path, cwd)
    cwd = cwd:sub(-1) == '/' and cwd or (cwd .. '/')
    return vim.startswith(path, cwd) and path:sub(cwd:len() + 1) or vim.fn.fnamemodify(path, ':~')
  end

  local items = vim.schedule_wrap(function()
    local cwd = pick.get_picker_opts().source.cwd
    local seen, res = {}, {}

    local cur_name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    if cur_name ~= '' then
      seen[full_path(cur_name)] = true
    end

    local buffers = vim.fn.getbufinfo({ buflisted = 1 })
    table.sort(buffers, function(a, b)
      return a.lastused > b.lastused
    end)
    for _, buf in ipairs(buffers) do
      if buf.name ~= '' and vim.bo[buf.bufnr].buftype == '' then
        local path = full_path(buf.name)
        if not seen[path] then
          seen[path] = true
          table.insert(res, { text = short_path(path, cwd), path = path, bufnr = buf.bufnr })
        end
      end
    end

    for _, path in ipairs(vim.v.oldfiles or {}) do
      path = full_path(path)
      if not seen[path] and vim.fn.filereadable(path) == 1 then
        seen[path] = true
        table.insert(res, { text = short_path(path, cwd), path = path })
      end
    end

    pick.set_picker_items(res)

    local cwd_slash = cwd:sub(-1) == '/' and cwd or (cwd .. '/')
    local postprocess = function(lines)
      local all = vim.deepcopy(res)
      for _, line in ipairs(lines) do
        local path = cwd_slash .. line
        if not seen[path] then
          seen[path] = true
          table.insert(all, { text = short_path(path, cwd), path = path })
        end
      end
      return all
    end
    pick.set_picker_items_from_cli(command, { postprocess = postprocess, spawn_opts = { cwd = cwd } })
  end)

  local show = (pick.config.source or {}).show
    or function(buf_id, its, query)
      pick.default_show(buf_id, its, query, { show_icons = true })
    end
  local opts_final =
    vim.tbl_deep_extend('force', { source = { name = 'Smart', show = show, items = items } }, opts or {})
  return pick.start(opts_final)
end

require('mini.pick').registry.smart = function(local_opts)
  return extra.pickers.smart(local_opts)
end
