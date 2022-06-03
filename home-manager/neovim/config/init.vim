set clipboard+=unnamedplus
set colorcolumn=80
set cursorline
set ignorecase
set list
set listchars=tab:→\ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set mouse=a
set nowrap
set number
set shell=bash
set shortmess+=c
set showbreak=↪
set splitright
set smartcase
set tabstop=2
set termguicolors
set updatetime=500
set virtualedit=all
set wrap

let g:markdown_fenced_languages = [
  \    'c', 'cpp', 'css', 'java', 'go', 'haskell', 'javascript',
  \    'js=javascript', 'json', 'python', 'scala', 'sh', 'typescript', 'yaml'
  \  ]

let g:do_filetype_lua = 1
let g:did_load_filetypes = 0

map q: <Nop>
nnoremap Q <Nop>
nnoremap <Space> <Nop>
map <Space> <Leader>

if $TERM == 'xterm-kitty'
  autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif
  autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif
endif

" Create file if it doesn't exist.
map <silent> gf <Cmd>execute('edit ' . fnamemodify(expand('%:p:h') . '/' . expand('<cfile>'), ':p'))<CR>

nnoremap <C-f> 5<C-e>
nnoremap <C-b> 5<C-y>

autocmd BufRead,BufNewFile *.fish set filetype=fish
autocmd BufRead,BufNewFile *.nix set filetype=nix
autocmd BufRead,BufNewFile *.sc set filetype=scala

autocmd FileType gitcommit,hgcommit setlocal colorcolumn=72
autocmd FileType go,java,sql setlocal colorcolumn=100
