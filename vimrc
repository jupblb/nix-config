" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on
 
" Enable syntax highlighting
syntax on

" Better command-line completion
set wildmenu
 
" Show partial commands in the last line of the screen
set showcmd
 
" Highlight searches
set hlsearch

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Always display the status line, even if only one window is displayed
set laststatus=2

" Display line numbers on the left
set number

" Timeout
set notimeout

call plug#begin('~/.vim/pack')

Plug 'gruvbox-community/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mhinz/vim-startify'
Plug 'easymotion/vim-easymotion'

call plug#end()

" gruvbox
let &t_ut=''
let g:gruvbox_contrast_light = 'hard'
let g:gruvbox_bold = '0'
let g:gruvbox_italic = '0'
colorscheme gruvbox

" Airline
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" NERDtree
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeShowIgnoredStatus = 1

" gitgutter
set updatetime=100

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

" vim-easymotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1
map <C-f> <Plug>(easymotion-overwin-f2)
map <C-j> <Plug>(easymotion-j)
map <C-k> <Plug>(easymotion-k)
