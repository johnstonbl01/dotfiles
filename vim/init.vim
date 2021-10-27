" ======================================
" Plugins
" ======================================
call plug#begin("~/.vim/plugged")
Plug 'tpope/vim-commentary'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'itchyny/lightline.vim'
Plug 'haishanh/night-owl.vim'
Plug 'pantharshit00/vim-prisma'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'Xuyuanp/nerdtree-git-plugin'
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
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html', 'javascriptreact', 'typescriptreact'] }
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

autocmd CursorHold * silent call CocActionAsync('highlight')

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
nnoremap <leader>ff :Telescope find_files<CR>
nnoremap <leader>fg :Telescope live_grep<CR>
nnoremap <leader>fb :Telescope buffers<CR>

" Close panes with q
nnoremap <leader>q :wincmd q<CR>
nnoremap <leader>ws :wincmd s<CR>
nnoremap <leader>wv :wincmd v<CR>
nnoremap <leader>wr :wincmd r<CR>
nnoremap <leader>wx :wincmd x<CR>

" Enables pane navigation with h/j/k/l
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" Use tab for autocomplete accept
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Toggle NerdTree
nnoremap <leader>a :NERDTreeToggle<CR>

" Reload VIMRC
nnoremap <leader>sv :source $MYVIMRC<CR>

" CoC GoTo navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)

" CoC Hover
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" CoC Diagnostics
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>

" ======================================
" Plugin Settings
" ======================================
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
let g:NERDTreeIgnore = ['node_modules']
let g:NERDTreeStatusLine='NERDTree'
let g:ale_disable_lsp = 1

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
EOF

" Treesitter setup
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = { "haskell" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  }
}
EOF
