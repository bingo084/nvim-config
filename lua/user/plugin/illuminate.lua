require("illuminate").configure({
	-- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
	filetypes_denylist = {
		"alpha",
		"NvimTree",
	},
	-- modes_denylist: modes to not illuminate, this overrides modes_allowlist
	-- See `:help mode()` for possible values
	modes_denylist = { "v", "V" },
})
vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
