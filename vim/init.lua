require("plugins")
require("impatient")
require("options")
require("key-mappings")
require("autocommands")

require("setup.tokyonight")
require("setup.nvim-tree")
require("setup.nvim-treesitter")
require("setup.telescope")
require("setup.lsp-config")
require("setup.cmp")
require("setup.dashboard")
require("setup.lualine")
require("setup.gitsigns")
require("setup.neoformat")
require("setup.comment")

-- Theme setup
vim.cmd [[colorscheme tokyonight]]
vim.cmd [[highlight NvimTreeFolderIcon guifg=#CCCCCC]]
