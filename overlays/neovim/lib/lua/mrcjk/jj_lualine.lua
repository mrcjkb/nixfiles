local M = {}

---@alias lualine.jj.AnsiCode '31'|'32'|'33'|'34'|'35'|'90'|'95'

---@class lualine.jj.AnsiStyle
---@field name string
---@field color string

---@class lualine.jj.Palette
---@field error string
---@field success string
---@field warning string
---@field info string
---@field accent string
---@field muted string

---@class lualine.jj.Component
---@field highlights? table<string, table>
---@field create_hl fun(self: lualine.jj.Component, color: { fg: string }, hint: string): table
---@field format_hl fun(self: lualine.jj.Component, highlight: table): string

---@class lualine.jj.AnsiToken
---@field code? lualine.jj.AnsiCode
---@field text? string

---@class lualine.jj.Statusline
---@field component fun(self: lualine.jj.Component): string
---@field is_in_workspace fun(): boolean

---@param palette lualine.jj.Palette
---@return lualine.jj.Statusline
function M.statusline(palette)
  if vim.fn.executable('jj-starship') ~= 1 then
    return {
      component = function()
        return ''
      end,
      is_in_workspace = function()
        return false
      end,
    }
  end

  ---@type table<lualine.jj.AnsiCode, lualine.jj.AnsiStyle>
  local ansi_colors = {
    ['31'] = { name = 'status', color = palette.error },
    ['32'] = { name = 'bookmark', color = palette.success },
    ['33'] = { name = 'status_empty', color = palette.warning },
    ['34'] = { name = 'symbol', color = palette.info },
    ['35'] = { name = 'change', color = palette.accent },
    ['90'] = { name = 'rest', color = palette.muted },
    ['95'] = { name = 'prefix', color = palette.accent },
  }

  ---@type { buffer: integer, root: string?, text: string }
  local state = { buffer = -1, root = nil, text = '' }
  ---@type vim.SystemObj?
  local job = nil
  ---@type uv.uv_fs_event_t?
  local watcher = nil
  ---@type fun()
  local load

  ---@param bufnr integer
  ---@return string?
  local function workspace_root(bufnr)
    local source = vim.api.nvim_buf_get_name(bufnr) ~= '' and bufnr or vim.fn.getcwd()
    return vim.fs.root(source, '.jj')
  end

  ---@param buffer integer
  ---@param root string
  local function starship(buffer, root)
    job = vim.system({ 'jj-starship', '--cwd', root }, { text = true }, function(completed)
      job = nil
      if completed.code ~= 0 or state.buffer ~= buffer then
        return
      end
      local text = vim.trim(((completed.stdout or ''):gsub('^on ', '')))
      vim.schedule(function()
        state.text = text
        require('lualine').refresh()
      end)
    end)
  end

  ---@param root string?
  local function watch(root)
    if watcher then
      watcher:stop()
      watcher = nil
    end
    if not root then
      return
    end
    local op_heads = vim.fs.joinpath(root, '.jj', 'repo', 'op_heads', 'heads')
    if vim.uv.fs_stat(op_heads) then
      watcher = assert(vim.uv.new_fs_event())
      watcher:start(op_heads, {}, vim.schedule_wrap(load))
    end
  end

  load = function()
    local buffer = vim.api.nvim_get_current_buf()
    local root = workspace_root(buffer)
    if job then
      job:kill(15)
      job = nil
    end
    if root ~= state.root then
      watch(root)
    end
    state.buffer, state.root, state.text = buffer, root, ''
    if root then
      starship(buffer, root)
    end
  end

  ---@param self lualine.jj.Component
  ---@param code lualine.jj.AnsiCode
  ---@return string
  local function highlight(self, code)
    local ansi_style = ansi_colors[code]
    if not ansi_style then
      return ''
    end
    self.highlights = self.highlights or {}
    if not self.highlights[code] then
      self.highlights[code] = self:create_hl({ fg = ansi_style.color }, 'jj_' .. ansi_style.name)
    end
    return self:format_hl(self.highlights[code])
  end

  ---@param text string
  ---@return lualine.jj.AnsiToken[]
  local function parse(text)
    ---@type lualine.jj.AnsiToken[]
    local tokens = {}
    local position = 1
    while true do
      local start_index, end_index, code = text:find('\27%[(%d+)m', position)
      if not start_index then
        tokens[#tokens + 1] = { text = text:sub(position) }
        break
      end
      if start_index > position then
        tokens[#tokens + 1] = { text = text:sub(position, start_index - 1) }
      end
      ---@cast code lualine.jj.AnsiCode
      tokens[#tokens + 1] = { code = code }
      position = end_index + 1
    end
    return tokens
  end

  ---@param self lualine.jj.Component
  ---@param tokens lualine.jj.AnsiToken[]
  ---@return string
  local function render(self, tokens)
    ---@type string[]
    local parts = {}
    for _, token in ipairs(tokens) do
      parts[#parts + 1] = token.code and highlight(self, token.code) or token.text or ''
    end
    return table.concat(parts)
  end

  ---@param self lualine.jj.Component
  ---@return string
  local function component(self)
    if state.buffer ~= vim.api.nvim_get_current_buf() or state.text == '' then
      return ''
    end
    return render(self, parse(state.text))
  end

  ---@return boolean
  local function is_in_workspace()
    return state.buffer == vim.api.nvim_get_current_buf() and state.root ~= nil
  end

  vim.api.nvim_create_autocmd({ 'UIEnter', 'BufEnter', 'BufWritePost', 'FocusGained' }, {
    group = vim.api.nvim_create_augroup('jj-lualine', {}),
    callback = load,
  })

  load()

  return { component = component, is_in_workspace = is_in_workspace }
end

return M
