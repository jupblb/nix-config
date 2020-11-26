set background=light
set clipboard+=unnamedplus
set colorcolumn=80
set completeopt=menuone,noinsert,noselect
set ignorecase
set mouse=a
set nowrap
set number
set relativenumber
set shell=bash
set shortmess+=c
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

nnoremap tn :tabnew<CR>
nnoremap td :tabclose<CR>

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

autocmd BufWinEnter <buffer> match Error /\s\+$/
autocmd InsertEnter <buffer> match Error /\s\+\%#\@<!$/
autocmd InsertLeave <buffer> match Error /\s\+$/
autocmd BufWinLeave <buffer> call clearmatches()

autocmd FileType go,java,sql set colorcolumn=100
autocmd FileType make set noexpandtab

