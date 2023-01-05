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
require("setup.comment")
require("setup.null-ls")

-- Theme setup
vim.cmd [[colorscheme tokyonight]]
vim.cmd [[highlight NvimTreeFolderIcon guifg=#CCCCCC]]

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})
