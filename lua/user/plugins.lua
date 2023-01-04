local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

local status_ok, packer = pcall(require, "packer")
if not status_ok then
	vim.notify("packer is not found!")
	return
end

vim.api.nvim_create_augroup("packer_user_config", {})
vim.api.nvim_create_autocmd("BufWritePost", {
	group = "packer_user_config",
	pattern = "plugins.lua",
	command = "source <afile> | PackerSync",
})

return packer.startup({
	function(use)
		-- Manage packer itself
		use("wbthomason/packer.nvim")
		-- My plugins here
		use({
			"kyazdani42/nvim-tree.lua",
			requires = {
				"kyazdani42/nvim-web-devicons",
			},
		})
		use("windwp/nvim-autopairs")
		use("numToStr/Comment.nvim") -- Easily comment stuff
		use("akinsho/bufferline.nvim")
		use("moll/vim-bbye")
		use("nvim-lualine/lualine.nvim")
		use({ "akinsho/toggleterm.nvim", tag = "v2.*" })
		use("ahmedkhalf/project.nvim")
		use("lewis6991/impatient.nvim")
		use("lukas-reineke/indent-blankline.nvim")
		use("goolord/alpha-nvim")
		use("folke/which-key.nvim")
		-- Session
		use("rmagatti/auto-session")
		use("rmagatti/session-lens")

		-- LSP
		use("williamboman/mason.nvim")
		use("williamboman/mason-lspconfig.nvim")
		use("neovim/nvim-lspconfig")
		use("SmiteshP/nvim-navic")
		use("RRethy/vim-illuminate")
		-- for formatters and linters
		use("jose-elias-alvarez/null-ls.nvim")
		use("ray-x/lsp_signature.nvim")
		use("b0o/SchemaStore.nvim")

		-- Colorschemes
		use("morhetz/gruvbox")
		use("joshdick/onedark.vim")
		use("folke/tokyonight.nvim")
		use("Mofiqul/dracula.nvim")
		use("catppuccin/nvim")
		-- cmp plugins
		use("hrsh7th/nvim-cmp") -- The completion plugin
		use("hrsh7th/cmp-buffer") -- buffer completions
		use("hrsh7th/cmp-path") -- path completions
		use("hrsh7th/cmp-cmdline")
		use("saadparwaiz1/cmp_luasnip")
		use("hrsh7th/cmp-nvim-lsp")
		use("hrsh7th/cmp-emoji")
		-- snippets
		use("L3MON4D3/LuaSnip") --snippet engine use 'hrsh7th/cmp-cmdline' -- cmdline completions
		-- Java
		use("mfussenegger/nvim-jdtls")
		-- Dap
		use("mfussenegger/nvim-dap")
		use("rcarriga/nvim-dap-ui")
		-- Telescope
		use({ "nvim-telescope/telescope.nvim", requires = {
			"nvim-lua/plenary.nvim",
		} })
		use("nvim-telescope/telescope-ui-select.nvim")
		-- Treesitter
		use("nvim-treesitter/nvim-treesitter")
		use("JoosepAlviste/nvim-ts-context-commentstring")
		use("p00f/nvim-ts-rainbow")
		use("windwp/nvim-ts-autotag")
		-- Git
		use("lewis6991/gitsigns.nvim")
		-- Vim-kitty-navigater
		use({ "knubie/vim-kitty-navigator", run = "cp ./*.py ~/.config/kitty/" })
		-- Color
		use("norcalli/nvim-colorizer.lua")
		-- Markdown
		use({
			"iamcco/markdown-preview.nvim",
			run = function()
				vim.fn["mkdp#util#install"]()
			end,
		})
		-- Motion
		use("ggandor/leap.nvim")
		-- Automatically set up your configuration after cloning packer.nvim
		-- Put this at the end after all plugins
		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = {
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "rounded" })
			end,
		},
	},
})
