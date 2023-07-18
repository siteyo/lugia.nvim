local Text = require("lugia.view.text")

local M = {}

---@param lines string[]
function M.status_short(lines)
	local text = Text.new()
	for _, line in ipairs(lines) do
		local X = string.sub(line, 1, 1)
		local Y = string.sub(line, 2, 2)
		if X == "?" and Y == "?" then
			text:append(line, { hl_group = "LugiaUnstaged", end_col = 2 })
		elseif X ~= " " and Y == " " then
			text:append(line, { hl_group = "LugiaStaged", end_col = 2 })
		elseif X == " " and Y ~= " " then
			text:append(line, { hl_group = "LugiaUnstaged", end_col = 2 })
		else
			text:append(line)
		end
	end
	return text
end

return M
