local View = require("lugia.view")
local Parser = require("lugia.view.parser")
local Git = require("lugia.git")

---@class Status
---@field view View
local M = {}

function M.new()
	---@type Status
	local self = setmetatable({}, { __index = M })
	return self:init()
end

function M:init()
	self.view = View.new({ name = "Lugia Status" })
	self:set_keymap()
	return self
end

function M:set_keymap()
	vim.keymap.set("n", "q", function()
		self:close()
	end, { buffer = self.view.buf })

	vim.keymap.set("n", "<cr>", function()
		self:go_to_file()
		self:close()
	end, { buffer = self.view.buf })
end

function M:update()
	local lines = Git.status("-s")
	local text = Parser.status_short(lines)
	self.view:render(text)
end

function M:go_to_file()
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
	self:update()
	self.view:open()
end

function M:close()
	self.view:close()
end

return M
