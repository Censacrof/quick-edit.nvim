local augroup = vim.api.nvim_create_augroup("quick-edit", { clear = true })

Buf = 0
local function get_quick_edit_buf()
	if Buf ~= 0 then
		return Buf
	end

	Buf = vim.api.nvim_create_buf(true, true)
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
		vim.api.nvim_set_current_win(win_list[1])
		return
	end

	-- make sure current window is quickfix list
	vim.cmd.copen()

	vim.api.nvim_win_set_buf(0, buf)
end

local function init_quick_edit_with_quickfix()
	local buf = get_quick_edit_buf()

	local qf_list = vim.fn.getqflist()
	local lines = {}

	local last_filename = nil
	for idx, entry in ipairs(qf_list) do
		-- bufnr = 10,
		-- col = 5,
		-- end_col = 11,
		-- end_lnum = 8,
		-- lnum = 8,
		-- module = "",
		-- nr = 0,
		-- pattern = "",
		-- text = 'vim.keymap.set("n", "<leader>a2", function() ui.nav_file(2) end, { desc = "Harpoon: go to file 2" })',
		-- type = "",
		-- valid = 1,
		-- vcol = 0
		local filename = vim.api.nvim_buf_get_name(entry.bufnr)
		if (filename ~= last_filename) then
			lines[#lines + 1] = ""
			lines[#lines + 1] = string.format("@%d|%s", idx, filename)
		end

		lines[#lines + 1] = string.format("#%d|%d:%d|%s", idx, entry.lnum, entry.col, entry.text)

		last_filename = filename
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
end

local function quick_edit_open()
	init_quick_edit_with_quickfix()
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
