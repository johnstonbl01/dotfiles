" ======================================
" Plugins
" ======================================
call plug#begin("~/.vim/plugged")
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'itchyny/lightline.vim'
Plug 'haishanh/night-owl.vim'
Plug 'pantharshit00/vim-prisma'
Plug 'pangloss/vim-javascript'
Plug 'peitalin/vim-jsx-typescript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdtree-project-plugin'
Plug 'neoclide/coc.nvim', { 'branch':'release' }
Plug 'editorconfig/editorconfig-vim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
let g:coc_global_extensions = ['coc-tsserver',
  \ 'coc-python',
  \ 'coc-pydocstring',
  \ 'coc-json',
  \ 'coc-html-css-support',
  \ 'coc-css',
  \ 'coc-go',
  \ 'coc-git',
  \ 'coc-sql',
  \ 'coc-prettier',
  \ 'coc-prisma',
  \ 'coc-yaml']
Plug 'preservim/nerdcommenter'
Plug 'jparise/vim-graphql'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'dense-analysis/ale'
Plug 'maximbaz/lightline-ale'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
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
"colorscheme night-owl

" ======================================
" Key Mapping
" ======================================
let mapleader = " "
" Open new tab to the side
nnoremap <leader>pv :Vex<CR>

" Open new finder to find files
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>

" Close panes with q
nnoremap <leader>q :wincmd q<CR>
nnoremap <leader>ws :wincmd s<CR>
nnoremap <leader>wv :wincmd v<CR>

" Enables pane navigation with h/j/k/l
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" Use tab for autocomplete accept
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-Y>" : "\<TAB>"
" Enables j/k navigation in automcomplete
" inoremap <expr> <C-J> pumvisible() ? "\<C-N>" : "j"
" inoremap <expr> <C-K> pumvisible() ? "\<C-P>" : "k"

" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Toggle NerdTree
nnoremap <leader>a :NERDTreeToggle<CR>

" Reload VIMRC
nnoremap <leader>sv :source $MYVIMRC<CR>

" ======================================
" Plugin Settings
" ======================================
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
let g:NERDTreeIgnore = ['node_modules']
let NERDTreeStatusLine='NERDTree'

" Set directory color in NerdTree
highlight Directory guifg=#CCCCCC
highlight File guifg=#777FA7

" let g:lightline = { 'colorscheme': 'nightowl' }
let g:lightline = { 'colorscheme': 'tokyonight' }

" Use prettier file in project instead of default
let g:prettier#autoformat_config_present = 1
let g:prettier#config#config_precedence = 'prefer-file'

" Ale settings
let g:ale_fixers = {
 \ 'javascript': ['eslint']
 \ }
 
let g:ale_sign_error = "\uf05e"
let g:ale_sign_warning = "\uf071"

let g:lightline.component_expand = {
  \  'linter_checking': 'lightline#ale#checking',
  \  'linter_infos': 'lightline#ale#infos',
  \  'linter_warnings': 'lightline#ale#warnings',
  \  'linter_errors': 'lightline#ale#errors',
  \  'linter_ok': 'lightline#ale#ok',
  \ }
let g:lightline.component_type = {
  \     'linter_checking': 'right',
  \     'linter_infos': 'right',
  \     'linter_warnings': 'warning',
  \     'linter_errors': 'error',
  \     'linter_ok': 'right',
  \ }

let g:lightline.active = { 'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ]] }
let g:lightline.active = {
  \ 'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
  \            [ 'lineinfo' ],
  \            [ 'percent' ],
  \            [ 'fileformat', 'fileencoding', 'filetype'] ] }

let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_infos = "\uf129"
let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf05e"
let g:lightline#ale#indicator_ok = "\uf00c"

" Use goimports for formatting
let g:go_fmt_command = "goimports"

" Telescope Setup
lua <<EOF
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    
      override_generic_sorter = true,  
      override_file_sorter = true,     
      case_mode = "smart_case",        
                                       
    }
  }
}

require('telescope').load_extension('fzf')
EOF
