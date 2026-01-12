local color = require("catppuccin.palettes.frappe")
local mode = { "mode", icon = "" }
local diagnostics = {
	"diagnostics",
	symbols = { error = " ", warn = " ", info = " ", hint = "󱠂 " },
}
local diff = {
	"diff",
	symbols = { added = " ", modified = " ", removed = " " },
}
local lazy = {
	require("lazy.status").updates,
	cond = require("lazy.status").has_updates,
	color = { fg = color.peach },
}
local branch = {
	"gitstatus",
	sections = {
		{ "branch", format = "{}" },
		{ "is_dirty", format = "*" },
	},
	icon = { "", color = { fg = color.peach } },
	sep = "",
}
local git_status = {
	"gitstatus",
	sections = {
		{ "ahead", format = "↑{}", hl = color.yellow },
		{ "behind", format = "↓{}", hl = color.yellow },
	},
	sep = "",
	padding = { left = 0, right = 1 },
}
local filetype = {
	"filetype",
	icon_only = true,
	padding = { left = 1, right = 0 },
}
local filename = {
	"filename",
	symbols = { unnamed = "" },
	file_status = false,
	color = function()
		local function is_new_file()
			local filename = vim.fn.expand("%")
			return filename ~= "" and vim.bo.buftype == "" and vim.fn.filereadable(filename) == 0
		end
		if vim.bo.modified then
			return { fg = color.red }
		elseif vim.bo.readonly then
			return { fg = color.overlay1 }
		elseif is_new_file() then
			return { fg = color.green }
		else
			return { fg = color.blue }
		end
	end,
	padding = 0,
}
local copilot = {
	"copilot",
	symbols = {
		status = {
			icons = { enabled = "", sleep = "", disabled = "", warning = "", unknown = "" },
			hl = {
				enabled = color.green,
				sleep = color.sky,
				disabled = color.subtext0,
				warning = color.peach,
				unknown = color.red,
			},
		},
		spinner_color = color.teal,
	},
	show_colors = true,
}
local lanuage_server = {
	function()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		local client_names = {}
		for _, client in pairs(clients) do
			if client.name ~= "copilot" then
				table.insert(client_names, client.name)
			end
		end
		local formatters = require("conform").list_formatters()
		for _, formatter in ipairs(formatters) do
			table.insert(client_names, formatter.name)
		end
		local unique_client = {}
		for _, value in ipairs(client_names) do
			unique_client[value] = true
		end
		local unique_client_names = {}
		for key, _ in pairs(unique_client) do
			table.insert(unique_client_names, key)
		end
		return "[" .. table.concat(unique_client_names, ", ") .. "]"
	end,
	cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) ~= 0 or #require("conform").list_formatters() ~= 0 end,
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"AndreM222/copilot-lualine",
		{ "abccsss/nvim-gitstatus", opts = {} },
	},
	opts = {
		options = {
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			globalstatus = true,
		},
		sections = {
			lualine_a = { mode },
			lualine_b = { branch, git_status },
			lualine_c = { filetype, filename, diagnostics },
			lualine_x = { diff, lazy },
			lualine_y = { lanuage_server, copilot, "encoding", "fileformat" },
			lualine_z = { { "progress", padding = { left = 1 } }, "location" },
		},
		extensions = { "lazy", "man", "mason", "nvim-dap-ui", "oil", "toggleterm" },
	},
	event = "VeryLazy",
}
