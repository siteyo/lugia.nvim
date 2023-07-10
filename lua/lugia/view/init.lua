local M = {}

function M.new(opts)
	local self = setmetatable({}, { __index = M })
	return self:init(opts or {})
end

function M:init(opts)
	self.buf = vim.api.nvim_create_buf(true, true) -- TODO: make it configurable

	if opts.name ~= nil then
		vim.api.nvim_buf_set_name(self.buf, opts.name)
	end
  return self
end

function M:open_file()
end

function M:open()
	vim.bo[self.buf].modifiable = false
	vim.api.nvim_set_current_buf(self.buf)
end

function M:close()
	vim.schedule(function()
		vim.api.nvim_buf_delete(self.buf, { force = true })
	end)
end

return M
