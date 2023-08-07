local Job = require("plenary.job")

---@alias Subcommand fun(...: string):string[]

---@class Git
---@field root_path string
---@field status Subcommand
local M = {}

---@param cmd string
local function command_factory(cmd)
  local cli = M.new()
  return function(...)
    local opts = { "--no-pager", "-C", cli.root_path }
    vim.list_extend(opts, { cmd, ... })
    return Job:new({ command = "git", args = opts }):sync()
  end
end

function M.new()
  local self = setmetatable({}, { __index = M })
  return self:init()
end

function M:init()
  self:find_root()
  return self
end

function M:find_root()
  Job:new({
    command = "git",
    args = { "rev-parse", "--show-toplevel" },
    on_stdout = function(_, line)
      self.root_path = line
    end,
  }):sync()
end

setmetatable(M, {
  __index = function(_, cmd)
    return command_factory(cmd)
  end,
})

return M
