local Text = require("lugia.view.text")

local M = {}

local status = {
	updated = "M",
	type_changed = "T",
	added = "A",
	deleted = "D",
	renamed = "R",
	copied = "C",
	untracked = "?",
	ignored = "!",
}

---@param lines string[]
function M.status_short(lines)
	local text = Text.new()
	for _, line in ipairs(lines) do
		local x = string.sub(line, 1, 1)
		local y = string.sub(line, 2, 2)
		local rest = string.sub(line, 3)
		if x == status.untracked or x == status.ignored then
			text:append(x, "LugiaUnstaged")
		else
			text:append(x, "LugiaStaged")
		end
		text:append(y, "LugiaUnstaged")
		text:append(rest)
		text:insert_newline()
	end
	return text
end

return M
