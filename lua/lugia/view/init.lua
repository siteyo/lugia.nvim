local Buffer = require("lugia.view.buffer")
local Window = require("lugia.view.window")

---@alias Callback fun(): nil

---@class ViewOptions
---@field buf_name string
---@field win_title? string
---@field win_border? "single" | "double" | "none"

---@class SetupOptions
---@field pre_open? Callback
---@field post_open? Callback
---@field pre_close? Callback
---@field post_close? Callback
---@field set_keymap? Callback

---@class View
---@field view? View
---@field buf Buffer
---@field win Window
local M = {}

M.view = nil
M.pre_open = nil
M.post_open = nil
M.pre_close = nil
M.post_close = nil
M.set_keymap = nil

function M.visible()
  return M.view and vim.api.nvim_buf_is_valid(M.view.buf:id())
end

---@param opts ViewOptions
function M.new(opts)
  ---@type View
  local self = setmetatable({}, { __index = M })
  return self:init(opts)
end

---@param opts ViewOptions
function M:init(opts)
  self.buf = Buffer.new({ name = opts.buf_name or "" })
  self.win = Window.new({ buf = self.buf:id(), title = opts.win_title or "", border = opts.win_border or "none" })
  self.target_win = vim.api.nvim_get_current_win()
  return self
end

---@param opts SetupOptions
function M:setup(opts)
  self.pre_open = opts.pre_open
  self.post_open = opts.post_open
  self.pre_close = opts.pre_close
  self.post_close = opts.post_close
  self.set_keymap = opts.set_keymap
  if self.set_keymap then
    self:set_keymap()
  end
end

function M:final()
  self.view = nil
  self.pre_open = nil
  self.post_open = nil
  self.pre_close = nil
  self.post_close = nil
  self.set_keymap = nil
end

function M:open()
  if self.pre_open then
    self:pre_open()
  end

  self.win:open()
  self.buf:open()

  if self.post_open then
    self:post_open()
  end
end

function M:close()
  if self.pre_close then
    self:pre_close()
  end

  self.win:close()
  self.buf:close()

  if self.post_close then
    self:post_close()
  end
  self:final()
end

return M
