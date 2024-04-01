-- Disable default file browser in favor of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.skip_ts_context_commentstring_module = true

require("plugins")
require("options")
require("key-mappings")

require("setup.nvim-tree")
require("setup.nvim-treesitter")
require("setup.telescope")
require("setup.lsp-config")
require("setup.mason")
require("setup.lua-snip")
require("setup.cmp")
require("setup.dashboard")
require("setup.lualine")
require("setup.auto-pairs")
require("setup.gitsigns")
require("setup.comment")
require("setup.null-ls")

-- Theme setup
vim.cmd([[colorscheme duskfox]])
vim.cmd([[highlight NvimTreeFolderIcon guifg=#CCCCCC]])

-- MDX support
vim.filetype.add({
	extension = {
		mdx = "mdx",
	},
})
