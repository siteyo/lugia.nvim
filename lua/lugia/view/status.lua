local View = require("lugia.view")
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
---@field view View
---@field buf Buffer
---@field win Window
---@field parsed_status ParsedStatus[]
---@field target_win number
local M = {}

---@type View
M.view = nil

function M.show()
  M.view = M.view and M.view.visible()
    or View.new({
      buf_name = "Lugia Status",
      win_title = "Lugia Status",
      win_border = "single",
    })
  M.view:setup({ set_keymap = M.set_keymap, pre_open = M.update })
  M.view:open()
end

function M:set_keymap()
  vim.keymap.set("n", "q", function()
    M.view:close()
    M.view = nil
  end, { buffer = M.view.buf:id() })

  vim.keymap.set("n", "<cr>", function()
    M:go_to_file()
    M.view:close()
  end, { buffer = M.view.buf:id() })
end

function M:update()
  vim.bo[M.view.buf:id()].modifiable = true
  local lines = Git.status("--porcelain")
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
  M.view.buf:render(text)
end

function M:go_to_file()
  local line = vim.api.nvim_get_current_line()
  local parsed = Parser.status_short_sl(line)
  vim.api.nvim_set_current_win(M.view.target_win)

  local target_path = parsed.path or parsed.orig_path
  vim.cmd("edit " .. target_path) --TODO: Do I need to check if the value is nil?
end

return M
