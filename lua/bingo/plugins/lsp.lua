---@type LazySpec
return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			vim.lsp.config("*", { capabilities = capabilities })

			local signs = { Error = "", Warn = "", Hint = "󱠂", Info = "" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
			vim.diagnostic.config({ update_in_insert = true, float = { border = "rounded" } })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local function map(mode, key, action, desc)
						vim.keymap.set(mode, key, action, { buffer = ev.buf, desc = desc })
					end
					map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
					map("n", "gD", vim.lsp.buf.type_definition, "Goto Declaration")
					map("n", "gi", vim.lsp.buf.implementation, "Goto References And Implementation")
					map("n", "gr", vim.lsp.buf.references, "Goto References And Implementation")
					map({ "n", "v", "i" }, "<A-Enter>", vim.lsp.buf.code_action, "Code Action")
					map("n", "K", function()
						local winid = require("ufo").peekFoldedLinesUnderCursor()
						if not winid then
							vim.lsp.buf.hover()
						end
					end, "Show Hover")
					map({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, "Signature Help")
					local function scroll_map(key, row, desc)
						vim.keymap.set({ "n", "i", "s" }, key, function()
							if not require("noice.lsp").scroll(row) then
								return key
							end
						end, { silent = true, expr = true, buffer = ev.buf, desc = desc })
					end
					scroll_map("<A-d>", 4, "Scroll Down")
					scroll_map("<A-u>", -4, "Scroll Up")
				end,
			})
		end,
		event = { "BufReadPre", "BufNewFile" },
		keys = { { "<leader>li", "<cmd>LspInfo<CR>", desc = "Info" } },
	},
	{
		"mason-org/mason.nvim",
		opts = {},
		keys = { { "<leader>lI", "<cmd>Mason<cr>", desc = "Installer Info" } },
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"bashls",
				"cssls",
				"html",
				"hyprls",
				"jdtls",
				"jsonls",
				"lua_ls",
				"rust_analyzer",
				"taplo",
				"ts_ls",
				"vue_ls",
				"yamlls",
			},
		},
		event = { "BufReadPre", "BufNewFile" },
	},
	{ "b0o/SchemaStore.nvim", lazy = true },
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "lazy.nvim", words = { "LazySpec" } },
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "mfussenegger/nvim-jdtls", version = false, lazy = true },
	{
		"ThePrimeagen/refactoring.nvim",
		opts = {},
		keys = {
			{ "<leader>xf", ":Refactor extract ", mode = "x", desc = "e[X]tract [F]unction" },
			{ "<leader>xF", ":Refactor extract_to_file ", mode = "x", desc = "e[X]tract [F]unction to file" },
			{ "<leader>xv", ":Refactor extract_var ", mode = "x", desc = "e[X]tract [V]ariable" },
			{ "<leader>iv", ":Refactor inline_var", mode = { "n", "x" }, desc = "[I]nline [V]ariable" },
			{ "<leader>if", ":Refactor inline_func", desc = "[I]nline [F]unction" },
			{ "<leader>xb", ":Refactor extract_block", desc = "[E]xtract [B]lock" },
			{ "<leader>xB", ":Refactor extract_block_to_file", desc = "[E]xtract [B]lock to file" },
		},
	},
}
