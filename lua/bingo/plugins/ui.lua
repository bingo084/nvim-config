-- [format-quickfix](https://github.com/kevinhwang91/nvim-bqf?tab=readme-ov-file#format-new-quickfix)
function _G.qftf(info)
	local fn = vim.fn
	local items
	local ret = {}
	if info.quickfix == 1 then
		items = fn.getqflist({ id = info.id, items = 0 }).items
	else
		items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
	end
	local limit = 31
	local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
	local validFmt = "%s │%5d:%-3d│%s %s"
	for i = info.start_idx, info.end_idx do
		local e = items[i]
		local fname = ""
		local str
		if e.valid == 1 then
			if e.bufnr > 0 then
				fname = fn.bufname(e.bufnr)
				if fname == "" then
					fname = "[No Name]"
				else
					fname = fname:gsub("^" .. vim.env.HOME, "~")
				end
				-- char in fname may occur more than 1 width, ignore this issue in order to keep performance
				if #fname <= limit then
					fname = fnameFmt1:format(fname)
				else
					fname = fnameFmt2:format(fname:sub(1 - limit))
				end
			end
			local lnum = e.lnum > 99999 and -1 or e.lnum
			local col = e.col > 999 and -1 or e.col
			local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
			str = validFmt:format(fname, lnum, col, qtype, e.text)
		else
			str = e.text
		end
		table.insert(ret, str)
	end
	return ret
end

vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
---@type LazySpec[]
return {
	{
		"folke/noice.nvim",
		dependencies = { { "MunifTanjim/nui.nvim", version = "*" }, { "rcarriga/nvim-notify", version = "*" } },
		version = "*",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = { long_message_to_split = true, inc_rename = true, lsp_doc_border = true },
			views = { popup = { size = { width = 0.5, height = 0.3 } } },
		},
		keys = {
			{
				"<S-Enter>",
				function() require("noice").redirect(vim.fn.getcmdline()) end,
				mode = "c",
				desc = "Redirect Cmdline",
			},
			{ "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Notification Clear" },
			{ "<leader>fn", function() require("noice").cmd("telescope") end, desc = "[F]ind [N]otify" },
		},
	},
	{
		"smjonas/inc-rename.nvim",
		opts = {},
		keys = { { "<leader>lr", ":IncRename <C-r><C-w>", desc = "Rename" } },
	},
	{
		"kevinhwang91/nvim-bqf",
		dependencies = { { "junegunn/fzf", build = function() vim.fn["fzf#install"]() end } },
		opts = {
			auto_resize_height = true,
			preview = { winblend = 0 },
			func_map = {
				drop = "o",
				openc = "O",
				split = "<C-s>",
				tabc = "",
				tabdrop = "<C-t>",
				pscrollup = "<A-u>",
				pscrolldown = "<A-d>",
			},
			filter = { fzf = { action_for = { ["ctrl-s"] = "split" } } },
		},
		ft = "qf",
	},
}
