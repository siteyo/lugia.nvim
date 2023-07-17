local M = {}

function M.setup(opts)
	require("lugia.config").setup(opts)
	require("lugia.commands").setup()
end

return M
