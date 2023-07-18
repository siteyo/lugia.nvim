local M = {}

function M.setup(opts)
  require("lugia.view.colors").setup()
	require("lugia.config").setup(opts)
	require("lugia.commands").setup()
end

return M
