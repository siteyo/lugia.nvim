local Config = require("lugia.config")

---@class Window
---@field win number
---@field target_win number
local M = {}

---@param buf number
function M.new(buf)
  local self = setmetatable({}, { __index = M })
  return self:init(buf)
end

---@param buf number
function M:init(buf)
  self.buf = buf
  self.win_opts = {
    relative = "editor",
    style = "minimal",
  }
  self.win_opts.width = math.floor(vim.o.columns * 0.8)
  self.win_opts.height = math.floor(vim.o.lines * 0.6)
  self.win_opts.row = math.floor((vim.o.lines - self.win_opts.height) / 2)
  self.win_opts.col = math.floor((vim.o.columns - self.win_opts.width) / 2)
  return self
end

function M:id()
  return self.win
end

function M:open()
  if Config.options.float then
    self.win = vim.api.nvim_open_win(self.buf, true, self.win_opts)
  else
    self.win = vim.api.nvim_get_current_win()
  end
end

function M:close()
  if Config.options.float then
    vim.schedule(function()
      vim.api.nvim_win_close(self.win, true)
    end)
  end
end

return M
