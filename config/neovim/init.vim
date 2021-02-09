set background=light
set clipboard+=unnamedplus
set colorcolumn=80
set completeopt=menuone,noinsert,noselect
set ignorecase
set mouse=a
set nohlsearch
set nowrap
set number
set relativenumber
set shell=bash
set shortmess+=c
set splitright
set smartcase
set termguicolors
set updatetime=500

nnoremap <Space> <Nop>
let mapleader="\<Space>"

set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

autocmd BufRead,BufNewFile *.nix set filetype=nix

autocmd BufWinEnter <buffer> match Error /\s\+$/
autocmd InsertEnter <buffer> match Error /\s\+\%#\@<!$/
autocmd InsertLeave <buffer> match Error /\s\+$/
autocmd BufWinLeave <buffer> call clearmatches()

autocmd FileType go,java,sql set colorcolumn=100
autocmd FileType make set noexpandtab
