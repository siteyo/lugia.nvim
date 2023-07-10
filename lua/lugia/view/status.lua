local View = require("lugia.view")

local M = {}

function M.new()
	local self = setmetatable({}, { __index = M })
	return self:init()
end

function M:init()
	self.view = View.new({ name = "Lugia Status" })
	self:setup()
	return self
end

function M:setup()
	vim.keymap.set("n", "q", function()
		self:close()
	end, { buffer = self.view.buf })

	vim.keymap.set("n", "<cr>", function()
		self:open_file()
    self:close()
	end, { buffer = self.view.buf })
end

function M:set_lines(lines)
	vim.api.nvim_buf_set_lines(self.view.buf, 0, -1, false, lines)
end

function M:open_file()
	local line = vim.api.nvim_get_current_line()
	local function trim(s)
		return string.gsub(s, "^%s*(.-)%s*$", "%1")
	end
	local function split(s)
		return vim.fn.split(s, " ")
	end
	local parse = split(trim(line))
	vim.cmd("edit " .. parse[2])
end

function M:open()
	self.view:open()
end

function M:close()
	self.view:close()
end

return M
