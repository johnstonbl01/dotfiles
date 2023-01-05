local g = vim.g
local map = vim.keymap.set

g.mapleader = ' '

-- Open Nvim Tree
map('n', '<Leader>a', [[:NvimTreeToggle<CR>]], { noremap = true, silent = true })

-- Dashboard
map ('n', '<Leader>cn', [[:DashboardNewFile<CR>]], { noremap = true, silent = true })

-- Telescope
map('n', '<Leader>ff', [[:Telescope find_files<CR>]], { noremap = true, silent = true, desc = '[F]ind [F]iles' })
map('n', '<Leader>fg', [[:Telescope live_grep<CR>]], { noremap = true, silent = true, desc = '[F]ind by [G]rep' })
map('n', '<Leader>fb', [[:Telescope buffers<CR>]], { noremap = true, silent = true, desc = '[F]ind in [B]uffer' })
map('n', '<Leader>fd', [[<cmd>lua require('setup.telescope').search_dotfiles()<CR>]], { noremap = true, silent = true, desc = '[F]ind in [D]otfiles' })
map('n', '<Leader>fr', [[:Telescope git_branches<CR>]], { noremap = true, silent = true, desc = '[F]ind git b[R]anch' })
map('n', '<Leader>fo', [[:Telescope oldfiles<CR>]], { noremap = true, silent = true, desc = '[F]ind [O]ld file' })
map('n', '<Leader>sh', [[:Telescope help_tags<CR>]], { noremap = true, silent = true, desc = '[S]earch [H]elp' })
map('n', '<Leader>sd', [[:Telescope diagnostics<CR>]], { noremap = true, silent = true, desc = '[S]earch [D]iagnostics' })

-- Pane Split Shortucts
map('n', '<Leader>q', [[:wincmd q<CR>]], { noremap = true })
map('n', '<Leader>ws', [[:wincmd s<CR>]], { noremap = true })
map('n', '<Leader>wv', [[:wincmd v<CR>]], { noremap = true })
map('n', '<Leader>wr', [[:wincmd r<CR>]], { noremap = true })
map('n', '<Leader>wx', [[:wincmd x<CR>]], { noremap = true })

-- Harpoon
map('n', '<Leader>hm', [[<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>]], { noremap = true })
map('n', '<Leader>ha', [[<cmd>lua require('harpoon.mark').add_file()<CR>]], { noremap = true })
map('n', '<Leader>h1', [[<cmd>lua require('harpoon.ui').nav_file(1)<CR>]], { noremap = true })
map('n', '<Leader>h2', [[<cmd>lua require('harpoon.ui').nav_file(2)<CR>]], { noremap = true })
map('n', '<Leader>h3', [[<cmd>lua require('harpoon.ui').nav_file(3)<CR>]], { noremap = true })

-- Pane Navigation
map('n', '<c-k>', [[:wincmd k<CR>]], { silent = true })
map('n', '<c-j>', [[:wincmd j<CR>]], { silent = true })
map('n', '<c-h>', [[:wincmd h<CR>]], { silent = true })
map('n', '<c-l>', [[:wincmd l<CR>]], { silent = true })

-- Toggle Trouble
map('n', '<Leader>tt', [[:TroubleToggle<CR>]], { noremap = true, silent = true })
map('n', '<Leader>tq', [[:TroubleToggle quickfix<CR>]], { noremap = true, silent = true })

-- Refresh vim init.lua
map('n', '<Leader>s', [[:source %<CR>]], { noremap = true })

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)
map('n', '<leader>e', vim.diagnostic.open_float)
map('n', '<leader>q', vim.diagnostic.setloclist)
