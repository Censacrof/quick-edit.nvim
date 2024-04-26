local augroup = vim.api.nvim_create_augroup("quick-edit", { clear = true })

local function quick_edit_open()
	local buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_name(buf, "*quick-edit*")
	vim.api.nvim_set_option_value("buftype", "nofile", {})

	vim.api.nvim_win_set_buf(0, buf)
end

local function main()
	vim.api.nvim_create_user_command("QuickEditOpen", quick_edit_open,
		{ desc = "Opens the quickfix list into a modifiable buffer" })
end

local function setup()
	vim.api.nvim_create_autocmd("VimEnter",
		{ group = augroup, desc = "Edit quickfix list as a regular buffer", once = true, callback = main })
end

return { setup = setup }
