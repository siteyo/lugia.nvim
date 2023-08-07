---@class BufferOptions
---@field name string

---@class Buffer
---@field buf number
local M = {}

---@param opts BufferOptions
function M.new(opts)
  ---@type Buffer
  local self = setmetatable({}, { __index = M })
  return self:init(opts or {})
end

---@param opts BufferOptions
function M:init(opts)
  self.buf = vim.api.nvim_create_buf(true, true) -- TODO: make it configurable

  if opts.name ~= nil then
    vim.api.nvim_buf_set_name(self.buf, opts.name)
  end
  return self
end

function M:id()
  return self.buf
end

function M:open()
  vim.bo[self.buf].modifiable = false
  vim.api.nvim_set_current_buf(self.buf)
end

function M:close()
  vim.schedule(function()
    vim.api.nvim_buf_delete(self.buf, { force = true })
  end)
end

---@param text Text
function M:render(text)
  text:render(self.buf)
end

return M
