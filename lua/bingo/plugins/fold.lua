local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = (" 󰁂 %d "):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	local rAlignAppndx = math.max(math.min(vim.opt.colorcolumn["_value"], width - 1) - curWidth - sufWidth, 0)
	suffix = (" "):rep(rAlignAppndx) .. suffix
	table.insert(newVirtText, { suffix, "MoreMsg" })
	return newVirtText
end
---@type LazySpec
return {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
			{
				"luukvbaal/statuscol.nvim",
				config = function()
					local builtin = require("statuscol.builtin")
					require("statuscol").setup({
						relculright = true,
						segments = {
							{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
							{ text = { "%s" }, click = "v:lua.ScSa" },
							{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
						},
					})
				end,
			},
		},
		init = function()
			vim.o.foldcolumn = "1"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
			vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
		end,
    ---@module "ufo"
		---@type UfoConfig
		---@diagnostic disable-next-line: missing-fields
		opts = {
			open_fold_hl_timeout = 200,
			close_fold_kinds_for_ft = {
				default = { "imports" },
			},
			preview = {
				win_config = { winblend = 0 },
				mappings = {
					scrollU = "<A-u>",
					scrollD = "<A-d>",
					jumpTop = "[",
					jumpBot = "]",
					switch = "K",
				},
			},
			fold_virt_text_handler = handler,
		},
		event = "VeryLazy",
	},
	{
		"chrisgrieser/nvim-origami",
		event = "VeryLazy",
		opts = {},
	},
}
