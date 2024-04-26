local augroup = vim.api.nvim_create_augroup("quick-edit", { clear = true })

local function main()
	print("Hello World")
end

local function setup()
	vim.api.nvim_create_autocmd("VimEnter",
		{ group = augroup, desc = "Edit quickfix list as a regular buffer", once = true, callback = main })
end

return { setup = setup }
