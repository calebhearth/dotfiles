local api = vim.api
local util = require('satellite.util')

--- @type Satellite.Handler
local handler = {
  name = 'aerial',
}

local HIGHLIGHT = 'AerialText'

--- @class Satellite.Handlers.AerialConfig: Satellite.Handlers.BaseConfig
--- @field enabled boolean
--- @field overlap boolean
--- @field priority integer
--- @field shape string visible|full|2stddev
handler.config = {
  enabled = true,
  overlap = true,
  priority = 10,
  width = 10,
  shape = 'visible',
}

local function setup_hl()
  api.nvim_set_hl(0, HIGHLIGHT, {
    default = true,
    fg = api.nvim_get_hl(0, { name = 'NonText' }).fg,
  })
end

--- @param user_config Satellite.Handlers.AerialConfig
--- @param update fun
function handler.setup(user_config, update)
  handler.config = vim.tbl_deep_extend('force', handler.config, user_config)
  local group = api.nvim_create_augroup('satellite_aerial', {})

  api.nvim_create_autocmd('ColorScheme', {
    group = group,
    callback = setup_hl
  })

  setup_hl()

  api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    group = group,
    callback = update,
  })
end

--- @param bufnr integer
--- @param winid integer
--- @return satellite.mark[]
function handler.update(bufnr, winid)
  if not handler.config.enabled then
    return
  end
  local marks = {} -- @type Satellite.Mark[]

  local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local content = table.concat(lines, '\n')
  local height = util.get_winheight(winid)
  local width = handler.config.width
  local wininfo = vim.fn.getwininfo(winid)[1]
  local vw = wininfo.width - wininfo.textoff

  local maxLineLength = 0
  for i = 1, #lines do
    if lines[i]:len() > maxLineLength then
      maxLineLength = lines[i]:len()
    end
  end

  local horiz = (2.0 * width / math.min(vw, maxLineLength))
  local vert = (4.0 * height / #lines)
  local handle = vim.system(
    {"code-minimap", "-H", horiz , "-V", vert },
    { text = true, stdin = content, stdout = true }
  ):wait()

  for line in handle.stdout:gmatch('[^\r\n]+') do
    marks[#marks+1] = {
      symbol = line,
      pos = math.floor((#marks + 0.5) * vert),
    }
  end
  return marks
end
require("satellite.handlers").register(handler)
