local mocha = require("catppuccin.palettes.mocha")
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
	color = { fg = mocha.peach },
}
local navic = {
	function() return require("nvim-navic").get_location end,
	cond = function() return require("nvim-navic").is_available end,
}
local branch = {
	"branch",
	icon = { "", color = { fg = mocha.peach } },
}
local copilot = {
	"copilot",
	symbols = {
		status = {
			icons = { enabled = "", sleep = "", disabled = "", warning = "", unknown = "" },
			hl = {
				enabled = mocha.green,
				sleep = mocha.sky,
				disabled = mocha.subtext0,
				warning = mocha.peach,
				unknown = mocha.red,
			},
		},
		spinner_color = mocha.teal,
	},
	show_colors = true,
}
local lanuage_server = {
	function()
		local clients = vim.lsp.get_active_clients({ bufnr = 0 })
		local client_names = {}
		for _, client in pairs(clients) do
			if client.name ~= "copilot" and client.name ~= "null-ls" then
				table.insert(client_names, client.name)
			end
		end
		local sources = require("null-ls.sources").get_available(vim.bo.filetype)
		for _, source in ipairs(sources) do
			table.insert(client_names, source.name)
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
	cond = function() return #vim.lsp.get_active_clients({ bufnr = 0 }) ~= 0 end,
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{ "SmiteshP/nvim-navic", opts = { highlight = true } },
		"AndreM222/copilot-lualine",
	},
	opts = {
		options = {
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			globalstatus = true,
		},
		sections = {
			lualine_a = { mode },
			lualine_b = { branch },
			lualine_c = { navic, diagnostics },
			lualine_x = { diff, lazy },
			lualine_y = { lanuage_server, copilot, "encoding", "fileformat", "filetype" },
			lualine_z = { "progress", "location" },
		},
		extensions = { "lazy", "man", "mason", "nvim-dap-ui", "oil", "toggleterm" },
	},
	event = "VeryLazy",
}
