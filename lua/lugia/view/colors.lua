local M = {}

M.did_setup = false

function M.setup()
	if M.did_setup then
		return
	end

	M.did_setup = true

	-- Status
	vim.api.nvim_set_hl(0, "LugiaStaged", { link = "String", default = true })
	vim.api.nvim_set_hl(0, "LugiaUnstaged", { link = "Error", default = true })
end

return M
