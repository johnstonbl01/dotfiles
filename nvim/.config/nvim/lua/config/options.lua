local map = vim.keymap.set
local option = vim.opt
local window = vim.wo

vim.syntax = true

option.scrolloff = 8
option.tabstop = 2
option.shiftwidth = 2
option.expandtab = true
option.smartindent = true
option.hidden = true
option.cmdheight = 0
option.updatetime = 250
option.timeoutlen = 300
option.shortmess:append({ c = true })
option.mouse = "a"
option.nu = true
option.swapfile = false
option.incsearch = true
option.inccommand = "split"
option.completeopt = "menu,menuone,noselect"
option.splitright = true
option.splitbelow = true
option.termguicolors = true
option.number = true
option.relativenumber = true
option.signcolumn = "yes"
option.ignorecase = true
option.smartcase = true
option.clipboard = "unnamedplus"
option.spelllang = "en_us"
option.spell = true
option.spelloptions = "camel"
option.showmode = false
option.undofile = true

-- Window
window.wrap = false

-- Clear highlights on search when pressing <Esc> in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Pane Split Shortucts
map("n", "<Leader>q", [[:wincmd q<CR>]], { noremap = true })
map("n", "<Leader>ws", [[:wincmd s<CR>]], { noremap = true })
map("n", "<Leader>wv", [[:wincmd v<CR>]], { noremap = true })
map("n", "<Leader>wr", [[:wincmd r<CR>]], { noremap = true })
map("n", "<Leader>wx", [[:wincmd x<CR>]], { noremap = true })

-- Switch Tmux Sessions
map("n", "<c-f>", [[:!tmux neww tmux-session-switch<CR>]], { noremap = true, silent = true })

-- Copy current file path
map("n", "<Leader>cf", '<cmd>:let @+= expand("%")<CR>')
