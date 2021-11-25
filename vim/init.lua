local g = vim.g

require('plugins')
require('options')
require('key-mappings')
require('autocommands')

require('setup.tokyonight')
require('setup.nvim-tree')
require('setup.nvim-treesitter')
require('setup.telescope')
require('setup.lsp-config')
require('setup.cmp')
require('setup.dashboard')
require('setup.lualine')
require('setup.gitsigns')
require('setup.neoformat')

-- Theme setup
vim.cmd[[colorscheme tokyonight]]



