return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"SmiteshP/nvim-navic",
		opts = { highlight = true },
	},
	config = function()
		M = {}
		local navic = require("nvim-navic")

		-- check if value in table
		local function contains(t, value)
			for _, v in pairs(t) do
				if v == value then
					return true
				end
			end
			return false
		end

		vim.api.nvim_set_hl(0, "SLCopilot", { fg = "#6CC644", bg = "#3e4451" })

		local mode = {
			"mode",
			icon = "",
		}

		local icons = require("bingo.icons")

		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn", "info", "hint" },
			symbols = {
				error = icons.diagnostics.Error .. " ",
				warn = icons.diagnostics.Warn .. " ",
				info = icons.diagnostics.Info .. " ",
				hint = icons.diagnostics.Hint .. " ",
			},
			update_in_insert = false,
			always_visible = false,
		}

		local diff = {
			"diff",
			symbols = {
				added = icons.git.Add .. " ",
				modified = icons.git.Mod .. " ",
				removed = icons.git.Remove .. " ",
			},
		}

		local branch = {
			"branch",
			icon = { "", color = { fg = "#E8AB53" } },
		}

		local lanuage_server = {
			function()
				local buf_ft = vim.bo.filetype
				local ui_filetypes = {
					"help",
					"packer",
					"neogitstatus",
					"NvimTree",
					"Trouble",
					"lir",
					"Outline",
					"spectre_panel",
					"toggleterm",
					"DressingSelect",
					"",
				}

				if contains(ui_filetypes, buf_ft) then
					return M.language_servers
				end

				local clients = vim.lsp.buf_get_clients()
				local client_names = {}
				local copilot_active = false

				-- add client
				for _, client in pairs(clients) do
					if client.name ~= "copilot" and client.name ~= "null-ls" then
						table.insert(client_names, client.name)
					end
					if client.name == "copilot" then
						copilot_active = true
					end
				end

				-- add formatter
				local s = require("null-ls.sources")
				local available_sources = s.get_available(buf_ft)
				local registered = {}
				for _, source in ipairs(available_sources) do
					for method in pairs(source.methods) do
						registered[method] = registered[method] or {}
						table.insert(registered[method], source.name)
					end
				end

				local formatter = registered["NULL_LS_FORMATTING"]
				local linter = registered["NULL_LS_DIAGNOSTICS"]
				if formatter ~= nil then
					vim.list_extend(client_names, formatter)
				end
				if linter ~= nil then
					vim.list_extend(client_names, linter)
				end

				-- join client names with commas
				local client_names_str = table.concat(client_names, ", ")

				-- check client_names_str if empty
				local language_servers = ""
				local client_names_str_len = #client_names_str
				if client_names_str_len ~= 0 then
					language_servers = "[" .. client_names_str .. "]"
				end
				if copilot_active then
					language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface
				end

				if client_names_str_len == 0 and not copilot_active then
					return ""
				else
					M.language_servers = language_servers
					return language_servers:gsub(", anonymous source", "")
				end
			end,
			padding = 1,
		}
		require("lualine").setup({
			options = {
				globalstatus = true,
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha", "dashboard" },
				always_divide_middle = true,
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { branch },
				lualine_c = { { navic.get_location, cond = navic.is_available }, diagnostics },
				lualine_x = {
					diff,
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
						color = { fg = "#ff9e64" },
					},
				},
				lualine_y = { lanuage_server, "encoding", "fileformat", "filetype" },
				lualine_z = { "progress", "location" },
			},
			extensions = { "nvim-dap-ui", "toggleterm", "nvim-tree" },
		})
	end,
	event = "VeryLazy",
}
