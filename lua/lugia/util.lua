local M = {}

---@param s string
function M.trim(s)
	return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

---@param s string
function M.wsplit(s)
	return vim.fn.split(s, " ")
end

return M
