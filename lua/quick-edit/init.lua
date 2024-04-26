local augroup = vim.api.nvim_create_augroup("quick-edit", { clear = true })

local function quick_edit_open()
	print("Hello World")
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
