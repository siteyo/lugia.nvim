---@class Config
local M = {}

M.defaults = {}

function M.setup(options)
	M.options = vim.tbl_deep_extend("force", {}, M.defaults, options or {})
end

M.namespace = vim.api.nvim_create_namespace("lugia")

return M
