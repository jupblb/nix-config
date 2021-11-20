set clipboard+=unnamedplus
set colorcolumn=80
set cursorline
set hidden
set ignorecase
set inccommand=nosplit
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

map q: <Nop>
nnoremap Q <Nop>
nnoremap <Space> <Nop>
map <Space> <Leader>

" Create file if it doesn't exist.
map <silent> gf <Cmd>execute('edit ' . fnamemodify(expand('%:p:h') . '/' . expand('<cfile>'), ':p'))<CR>

autocmd BufRead,BufNewFile *.fish set filetype=fish
autocmd BufRead,BufNewFile *.nix set filetype=nix
autocmd BufRead,BufNewFile *.sc set filetype=scala

autocmd FileType gitcommit,hgcommit set colorcolumn=72
autocmd FileType go,java,sql set colorcolumn=100
