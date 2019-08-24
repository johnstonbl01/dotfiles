call plug#begin('~/.vim/plugged')

Plug 'sheerun/vim-polyglot'
Plug 'pangloss/vim-javascript'

" Themes
Plug 'KeitaNakamura/neodark.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'morhetz/gruvbox'
Plug 'MaxSt/FlatColor'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'danilo-augusto/vim-afterglow'
Plug 'jacoborus/tender.vim'
Plug 'marcopaganini/termschool-vim-theme'
Plug 'rakr/vim-two-firewatch'

call plug#end()

" Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
" If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
" (see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

syntax on

set backspace=2 " make backspace work like most other programs

" Themes
colorscheme neodark
" colorscheme onedark
" set background=dark
" colorscheme PaperColor
" colorscheme gruvbox
" colorscheme flatcolor
" set background=dark
" colorscheme deep-space
" colorscheme afterglow
" colorscheme tender
" colorscheme termschool
" set background=dark
" let g:two_firewatch_italics=1
" colorscheme two-firewatch
