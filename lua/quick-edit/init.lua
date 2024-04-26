local augroup = vim.api.nvim_create_augroup("quick-edit", { clear = true })

Buf = 0
local function get_quick_edit_buf()
	if Buf ~= 0 then
		return Buf
	end

	Buf = vim.api.nvim_create_buf(true, false)
	if Buf == 0 then
		error("Error creating quick-edit buffer")
	end

	vim.api.nvim_buf_set_name(Buf, "quick-edit")
	vim.api.nvim_set_option_value("buftype", "nofile", {})

	return Buf
end

local function open_quick_edit_window()
	local buf = get_quick_edit_buf()

	local win_list = vim.fn.win_findbuf(buf)

	if #win_list > 0 then
		return
	end

	-- make sure current window is quickfix list
	vim.cmd.copen()

	vim.api.nvim_win_set_buf(0, buf)
end

local function quick_edit_open()
	open_quick_edit_window()
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
