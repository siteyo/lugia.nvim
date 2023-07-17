local Config = require("lugia.config")

---@class ViewOptions
---@field name string

---@class View
---@field buf number
local M = {}

function M.new(opts)
	---@type View
	local self = setmetatable({}, { __index = M })
	return self:init(opts or {})
end

function M:init(opts)
	self.buf = vim.api.nvim_create_buf(true, true) -- TODO: make it configurable

	if opts.name ~= nil then
		vim.api.nvim_buf_set_name(self.buf, opts.name)
	end
	return self
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
	local lines = {}
	for _, line in ipairs(text.lines) do
		table.insert(lines, line.str)
	end

	vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
	vim.api.nvim_buf_clear_namespace(self.buf, Config.namespace, 0, -1)

	for l, line in ipairs(text.lines) do
		local extmark = line.hl
		if extmark then
			if type(extmark) == "string" then
				extmark = { hl_group = extmark, end_col = vim.fn.strlen(line.str) }
			end
			---@cast extmark Extmark
			vim.api.nvim_buf_set_extmark(self.buf, Config.namespace, l - 1, 0, extmark)
		end
	end
end

return M
