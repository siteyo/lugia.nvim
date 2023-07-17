---@alias TextSegment {str: string, hl?:string|Extmark}
---@alias Extmark {hl_group?:string, end_col?:number}

---@class Text
---@field lines TextSegment[]
local Text = {}

function Text.new()
	local self = setmetatable({}, { __index = Text })
	self.lines = {}
	return self
end

---@param str string
---@param hl? string|Extmark
function Text:append(str, hl)
	local splited_lines = vim.split(str, "\n")
	for _, line in ipairs(splited_lines) do
		table.insert(self.lines, { str = line, hl = hl })
	end
	return self
end

return Text
