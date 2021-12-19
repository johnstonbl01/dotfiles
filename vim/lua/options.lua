local option = vim.opt
local window = vim.wo

-- Global
vim.syntax = true
option.scrolloff = 8
option.tabstop = 2
option.shiftwidth = 2
option.expandtab = true
option.smartindent = true
option.hidden = true
option.cmdheight = 2
option.updatetime = 300
option.shortmess:append({ c = true })
option.mouse = 'a'
option.nu = true
option.swapfile = false
option.incsearch = true
option.completeopt = 'menu,menuone,noselect'
option.splitright = true
option.splitbelow = true
option.termguicolors = true
option.number = true
option.relativenumber = true
option.signcolumn = 'yes'
option.ignorecase = true
option.smartcase = true
option.clipboard = 'unnamedplus'
option.confirm = true

-- Window
window.wrap = false
