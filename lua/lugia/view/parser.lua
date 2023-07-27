local Util = require("lugia.util")

-- local Text = require("lugia.view.text")

local M = {}

---@param lines string[]
function M.status_short_ml(lines)
	---@type ParsedStatus[]
	local parsed = {}

	-- local text = Text.new()
	for _, line in ipairs(lines) do
		table.insert(parsed, {})
    parsed[#parsed] = M.status_short_sl(line)
	end
	return parsed
	-- return text
end

---@param line string
function M.status_short_sl(line)
	---@type ParsedStatus
	local parsed = {}
	parsed.xcode = string.sub(line, 1, 1)
	parsed.ycode = string.sub(line, 2, 2)

	local paths = Util.wsplit(string.sub(line, 4))
	parsed.orig_path = paths[1]
	if #paths > 1 then
		parsed.path = paths[3]
	end

	return parsed
end

return M
