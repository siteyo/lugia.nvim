local Buffer = require("lugia.view.buffer")
local Parser = require("lugia.view.parser")
local Text = require("lugia.view.text")
local Git = require("lugia.git")

local status_code = {
  updated = "M",
  type_changed = "T",
  added = "A",
  deleted = "D",
  renamed = "R",
  copied = "C",
  untracked = "?",
  ignored = "!",
}

---@alias ParsedStatus {nr: number, xcode: string, ycode: string, orig_path: string, path?: string}

---@class StatusView
---@field view StatusView
---@field buf Buffer
---@field parsed_status ParsedStatus[]
local M = {}

M.view = nil

function M.visible()
  return M.view and vim.api.nvim_buf_is_valid(M.view.buf)
end

function M.show()
  M.view = M.visible() and M.view or M.new()
  M.view:open()
end

function M.new()
  ---@type StatusView
  local self = setmetatable({}, { __index = M })
  return self:init()
end

function M:init()
  self.buf = Buffer.new({ name = "Lugia Status" })
  self:set_keymap()
  return self
end

function M:set_keymap()
  vim.keymap.set("n", "q", function()
    self:close()
  end, { buffer = self.buf:id() })

  vim.keymap.set("n", "<cr>", function()
    self:go_to_file()
    self:close()
  end, { buffer = self.buf:id() })
end

function M:update()
  vim.bo[self.buf:id()].modifiable = true
  local lines = Git.status("-s")
  self.parsed_status = Parser.status_short_ml(lines)
  local text = Text.new()
  for _, line in ipairs(self.parsed_status) do
    if line.xcode == status_code.untracked or line.xcode == status_code.ignored then
      text:append(line.xcode, "LugiaUnstaged")
    else
      text:append(line.xcode, "LugiaStaged")
    end
    text:append(line.ycode, "LugiaUnstaged")
    text:append(" ")
    text:append(line.orig_path)
    if line.path then
      text:append(" -> " .. line.path)
    end
    text:insert_newline()
  end
  self.buf:render(text)
end

function M:go_to_file()
  local line = vim.api.nvim_get_current_line()
  local parsed = Parser.status_short_sl(line)
  vim.cmd("edit " .. parsed.orig_path) --TODO: Do I need to check if the value is nil?
end

function M:open()
  self:update()
  self.buf:open()
end

function M:close()
  self.buf:close()
  M.view = nil
end

return M
