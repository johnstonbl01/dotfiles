-- Inspired by https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
-- Install package manager (Packer)
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false

vim.loader.enable()

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	is_bootstrap = true
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
	vim.cmd([[packadd packer.nvim]])
end

require("packer").startup(function(use)
	-- Package manager
	use("wbthomason/packer.nvim")

	-- Themes
	use("EdenEast/nightfox.nvim")

	-- Icons
	use("kyazdani42/nvim-web-devicons")

	-- File management
	use("nvim-lua/plenary.nvim")
	use("ThePrimeagen/harpoon")
	use({
		"kyazdani42/nvim-tree.lua",
		requires = { "kyazdani42/nvim-web-devicons" },
	})
	use({
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		requires = { "nvim-lua/plenary.nvim" },
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	-- Syntax highlighting
	use({
		"neovim/nvim-lspconfig",
		requires = {
			-- Auto-install LSPs
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Status updates for LSP installation
			"j-hui/fidget.nvim",
		},
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})

	-- Autocomplete
	use({ "L3MON4D3/LuaSnip", tag = "v2.*", run = "make install_jsregexp" })
	use("rafamadriz/friendly-snippets")
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"saadparwaiz1/cmp_luasnip",
		},
	})

	-- Formatting
	use("numToStr/Comment.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("windwp/nvim-autopairs")
	use("tpope/vim-sleuth")
	use({ "nvimtools/none-ls.nvim", requires = { "nvim-lua/plenary.nvim" } })

	-- Lualine
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- Git
	use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })

	-- Misc
	use("folke/neodev.nvim")
	use({ "folke/trouble.nvim", requires = { "kyazdani42/nvim-web-devicons" }, opts = {} })
	use({
		"nvimdev/dashboard-nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
	})
	use("ThePrimeagen/vim-be-good")
	use("christoomey/vim-tmux-navigator")

	if is_bootstrap then
		require("packer").sync()
	end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
	print("==================================")
	print("    Plugins are being installed")
	print("    Wait until Packer completes,")
	print("       then restart nvim")
	print("==================================")
	return
end
