local M = {}

---@param s string
function M.trim(s)
	return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

---@param s string
---@return string[]
function M.wsplit(s)
	return vim.split(s, " ", { trimempty = true })
end

return M
