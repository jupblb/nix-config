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

autocmd FileType go,java,sql set colorcolumn=100
autocmd FileType make set noexpandtab

if filereadable(expand("~/.config/nvim/google.vim"))
  source ~/.config/nvim/google.vim
endif

