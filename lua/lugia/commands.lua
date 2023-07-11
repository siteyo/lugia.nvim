local Git = require("lugia.git")

---@class Commands
local M = {}

function M.setup()
	vim.api.nvim_create_user_command("LugiaStatus", function()
		local view = require("lugia.view.status").new()

		local lines = Git.status("-s")
		view:set_lines(lines)

		view:open()
	end, {})

	vim.api.nvim_create_user_command("LugiaCommit", function()
		vim.notify("Not yet implemented...")
	end, {})
end

return M
