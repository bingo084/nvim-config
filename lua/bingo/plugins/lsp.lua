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

			vim.diagnostic.config({
				update_in_insert = true,
				float = { border = "rounded" },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "󱠂",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
			})

			vim.keymap.del({ "n", "x" }, "gra")
			vim.keymap.del("n", "gri")
			vim.keymap.del("n", "grn")
			vim.keymap.del("n", "grr")
			vim.keymap.del("n", "grt")
			vim.keymap.del("n", "gO")
			vim.keymap.del({ "i", "s" }, "<C-s>")

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local function map(mode, key, action, desc)
						vim.keymap.set(mode, key, action, { buffer = ev.buf, desc = desc })
					end
					map("n", "gd", vim.lsp.buf.definition, "Goto [D]efinition")
					map("n", "gD", vim.lsp.buf.declaration, "Goto [D]eclaration")
					map("n", "gi", vim.lsp.buf.implementation, "Goto [I]mplementation")
					map("n", "gI", vim.lsp.buf.incoming_calls, "Goto [I]ncoming Calls")
					map("n", "gO", vim.lsp.buf.outgoing_calls, "Goto [O]utgoing Calls")
					map(
						"n",
						"gr",
						function() vim.lsp.buf.references({ includeDeclaration = false }) end,
						"Goto [R]eferences"
					)
					map("n", "gy", vim.lsp.buf.type_definition, "Goto [D]eclaration")
					map(
						{ "n", "v", "i" },
						"<A-Enter>",
						function() require("tiny-code-action").code_action({}) end,
						"Code Action"
					)
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
				"gopls",
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
