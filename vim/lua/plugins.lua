vim.cmd[[packadd packer.nvim]]

return require('packer').startup(function()
  -- Package maanger
  use 'wbthomason/packer.nvim'

  -- Themes
  use 'folke/tokyonight.nvim'
  use 'folke/lsp-colors.nvim'

  -- Icons
  use 'kyazdani42/nvim-web-devicons'

  -- File management
  use 'nvim-lua/plenary.nvim'
  use { 'kyazdani42/nvim-tree.lua', requires = { 'kyazdani42/nvim-web-devicons' } }
  use 'ThePrimeagen/harpoon'
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'nvim-telescope/telescope.nvim'

  -- Syntax highlighting
  use 'neovim/nvim-lspconfig'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- Autocomplete
  use 'windwp/nvim-ts-autotag'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'jiangmiao/auto-pairs'
  use 'tpope/vim-commentary'

  -- Snippets
  use 'onsails/lspkind-nvim'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'

  -- Formatting
  use 'sbdchd/neoformat'
  use 'editorconfig/editorconfig-vim'

  -- Lualine
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }

  -- Git
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  -- Misc
  use { "folke/trouble.nvim", requires = { "kyazdani42/nvim-web-devicons" } }
  use 'glepnir/dashboard-nvim'
  use 'ThePrimeagen/vim-be-good'
  use 'lewis6991/impatient.nvim'
end)
