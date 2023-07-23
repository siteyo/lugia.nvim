local Git = require("lugia.git")

---@class Commands
local M = {}

function M.setup()
	vim.api.nvim_create_user_command("LugiaStatus", function()
		require("lugia.view.status").show()
	end, {})

	vim.api.nvim_create_user_command("LugiaCommit", function()
		vim.notify("Not yet implemented...")
	end, {})
end

return M
