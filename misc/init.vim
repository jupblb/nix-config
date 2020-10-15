set background=light
set colorcolumn=80
set clipboard+=unnamedplus
set ignorecase
set mouse=a
set nowrap
set number
set relativenumber
set shell=bash
set smartcase
set termguicolors
set splitright
set nohlsearch

nnoremap <Space> <Nop>
let mapleader="\<Space>"

set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt

nnoremap th :tabfirst<CR>
nnoremap tk :tabnext<CR>
nnoremap tj :tabprev<CR>
nnoremap tl :tablast<CR>
nnoremap tt :tabedit<Space>
nnoremap tn :tabnew<CR>
nnoremap tm :tabm<Space>
nnoremap td :tabclose<CR>

autocmd FileType go,java,sql set colorcolumn=100
autocmd FileType make set noexpandtab

if filereadable(expand("~/.config/nvim/init.vim"))
  source ~/.config/nvim/init.vim
endif

