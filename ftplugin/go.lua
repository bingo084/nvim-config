local tags = require("bingo.gomodifytags")

vim.api.nvim_buf_create_user_command(0, "GoTagAdd", function(opts) tags.add_tags(opts) end, {
	range = true,
	bang = true,
	nargs = "*",
	desc = "Add struct tags (! = override)",
})

vim.api.nvim_buf_create_user_command(0, "GoTagRm", function(opts) tags.remove_tags(opts) end, {
	range = true,
	nargs = "*",
	desc = "Remove struct tags (no args = clear all)",
})
