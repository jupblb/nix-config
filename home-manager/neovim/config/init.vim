set clipboard+=unnamedplus
set cmdheight=0
set colorcolumn=80
set cursorline
set exrc
set foldlevel=99
set ignorecase
set laststatus=0
set list
set listchars=tab:→\ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set mouse=a
set mousemodel=extend
set nowrap
set number
set relativenumber
set shell=bash
set shortmess+=c
set showbreak=↪
set splitright
set smartcase
set tabstop=2
set updatetime=500
set virtualedit=all
set wrap

map q: <Nop>
nnoremap Q <Nop>
nnoremap <ESC> <Nop>
nnoremap <Space> <Nop>
map <Space> <Leader>

" https://github.com/neovim/neovim/issues/20126#issuecomment-1243465684
nnoremap <C-I> <C-I>

" Create file if it doesn't exist.
map <silent> gf <Cmd>execute('edit ' . fnamemodify(expand('%:p:h') . '/' . expand('<cfile>'), ':p'))<CR>

" Copy path to clipboard
nnoremap <C-g> <Cmd>let @+ = expand("%")<CR><C-g>

nnoremap <S-CR> -
nnoremap <C-f> 5<C-e>
nnoremap <C-b> 5<C-y>
vnoremap p "_dP

autocmd VimResized * wincmd =

autocmd InsertEnter * setlocal norelativenumber
autocmd InsertLeave * setlocal relativenumber

autocmd BufRead,BufNewFile *.arb  set filetype=json
autocmd BufRead,BufNewFile *.fish set filetype=fish
autocmd BufRead,BufNewFile *.log  set filetype=text
autocmd BufRead,BufNewFile *.nix  set filetype=nix
autocmd BufRead,BufNewFile *.sc   set filetype=scala
autocmd BufRead,BufNewFile .envrc set filetype=sh

autocmd FileType cpp                setlocal commentstring=//\ %s
autocmd FileType gitcommit,hgcommit setlocal colorcolumn=72
autocmd FileType java,kotlin,sql    setlocal colorcolumn=100
autocmd FileType markdown           setlocal expandtab shiftwidth=4
autocmd FileType mermaid            setlocal commentstring=%%\ %s
autocmd FileType qf                 setlocal colorcolumn=0

command W :write
