---@class Config
local M = {}

---@class ConfigOptions
---@field float boolean
M.defaults = {
  float = true,
}

function M.setup(options)
  ---@type ConfigOptions
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, options or {})
end

M.namespace = vim.api.nvim_create_namespace("lugia")

return M
