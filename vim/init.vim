" ======================================
" Plugins
" ======================================
call plug#begin("~/.vim/plugged")
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'folke/trouble.nvim'
Plug 'glepnir/dashboard-nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'tpope/vim-commentary'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-lua/plenary.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'nvim-telescope/telescope.nvim'
Plug 'folke/lsp-colors.nvim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'jiangmiao/auto-pairs'
Plug 'editorconfig/editorconfig-vim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'windwp/nvim-ts-autotag'
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html', 'javascriptreact', 'typescriptreact'] }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lualine/lualine.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'lewis6991/gitsigns.nvim'
call plug#end()

" ======================================
" Settings
" ======================================
" Support for jsonc
autocmd FileType json syntax match Comment +\/\/.\+$+

set scrolloff=8
set nowrap
set number
set relativenumber
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set hidden
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes
set mouse=a
set nu
set noswapfile
set incsearch
set completeopt=menu,menuone,noselect

" Open new split panes to right and below
set splitright
set splitbelow

if (has("termguicolors"))
 set termguicolors
endif

let g:tokyonight_style = "storm"
let g:tokyonight_italic_functions = 0
let g:tokyonight_sidebars = [ "qf", "vista_kind", "terminal", "packer" ]

syntax enable
colorscheme tokyonight

" ======================================
" Key Mapping
" ======================================
let mapleader = " "
" Open new tab to the side
nnoremap <leader>pv :Vex<CR>

" Open new finder to find files
nnoremap <leader>ff :Telescope find_files<CR>
nnoremap <leader>fg :Telescope live_grep<CR>
nnoremap <leader>fb :Telescope buffers<CR>

" Close panes with q
nnoremap <leader>q :wincmd q<CR>
nnoremap <leader>ws :wincmd s<CR>
nnoremap <leader>wv :wincmd v<CR>
nnoremap <leader>wr :wincmd r<CR>
nnoremap <leader>wx :wincmd x<CR>

" Harpoon conifg keybindings
nnoremap <leader>hm :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>ha :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader>h1 :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader>h2 :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader>h3 :lua require("harpoon.ui").nav_file(3)<CR>

" Enables pane navigation with h/j/k/l
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" nnoremap <silent> gh :Lspsaga lsp_finder<CR>
" nnoremap <silent> <leader>ca :Lspsaga code_action<CR>
" nnoremap <silent>K :Lspsaga hover_doc<CR>
" nnoremap <silent> gd :Lspsaga preview_definition<CR>
" nnoremap <silent> gs :Lspsaga signature_help<CR>

nnoremap <leader>a :NvimTreeToggle<CR>

" ======================================
" Plugin Settings
" ======================================
let g:go_fmt_command = "goimports"

" Set directory color in NvimTree
highlight NvimTreeFolderIcon guifg=#CCCCCC

let g:dashboard_default_executive = 'telescope'

let g:nvim_tree_gitignore = 1 
let g:nvim_tree_quit_on_open = 1 
let g:nvim_tree_indent_markers = 1 
let g:nvim_tree_git_hl = 1

let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }

" Use prettier file in project instead of default
let g:prettier#autoformat_config_present = 1
let g:prettier#config#config_precedence = 'prefer-file'

let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']

" Telescope Setup
lua <<EOF
require('telescope').setup {
  pickers = {
    find_files = {
      -- Include hidden files except for .git
      find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                    
      override_generic_sorter = true,  
      override_file_sorter = true,     
      case_mode = "smart_case",        
    },
  },
}

require('telescope').load_extension('fzf')

require'nvim-treesitter.configs'.setup {
  autotag = {
    enable = true
  },
  ensure_installed = "all",
  ignore_install = { "haskell" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  }
}

require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  auto_close          = false,
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  update_to_buf_dir   = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    auto_resize = false,
    mappings = {
      custom_only = false,
      list = {}
    }
  }
}

local cmp = require'cmp'

cmp.setup({
snippet = {
  expand = function(args)
  vim.fn["vsnip#anonymous"](args.body)
end,
},
    mapping = {
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
      }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
  sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'vsnip' }
  }, {
  { name = 'buffer' },
  })
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
end

local servers = { 'html', 'cssls', 'tsserver', 'graphql', 'tailwindcss', 'yamlls', 'terraformls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

require'trouble'.setup {}
require'colorizer'.setup()
require'gitsigns'.setup()

require('lualine').setup {
  options = {
    theme = 'tokyonight'
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff',
                  {'diagnostics', sources={'nvim_lsp', 'coc'}}},
    lualine_c = { {'filename', file_status = true, path = 1 } },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}
EOF

