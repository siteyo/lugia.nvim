local Config = require("lugia.config")

---@alias TextSegment {str: string, hl?:string|Extmark}
---@alias Extmark {hl_group?:string, end_col?:number}

---@class Text
---@field lines TextSegment[][]
local Text = {}

function Text.new()
	local self = setmetatable({}, { __index = Text })
	self.lines = {}
	return self
end

---@param str string
---@param hl? string|Extmark
function Text:append(str, hl)
	if #self.lines == 0 then
		self:insert_newline()
	end
	table.insert(self.lines[#self.lines], { str = str, hl = hl })
	return self
end

function Text:insert_newline()
	table.insert(self.lines, {})
end

---@param buf number
function Text:render(buf)
	local lines = {}
	for _, line in ipairs(self.lines) do
		local str = ""
		for _, segment in ipairs(line) do
			str = str .. segment.str
		end
		table.insert(lines, str)
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_clear_namespace(buf, Config.namespace, 0, -1)

	for l, line in ipairs(self.lines) do
		local col = 0
		for _, segment in ipairs(line) do
			local len = vim.fn.strlen(segment.str)
			local extmark = segment.hl
			if extmark then
				if type(extmark) == "string" then
					extmark = { hl_group = extmark, end_col = col + len }
				end
				---@cast extmark Extmark
				vim.api.nvim_buf_set_extmark(buf, Config.namespace, l - 1, col, extmark)
			end
			col = col + len
		end
	end
end

return Text
