set background=light
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
set wrap

map q: <Nop>
nnoremap Q <Nop>
nnoremap <Space> <Nop>
map <Space> <Leader>

autocmd BufRead,BufNewFile *.fish set filetype=fish
autocmd BufRead,BufNewFile *.nix set filetype=nix
autocmd BufRead,BufNewFile *.sc set filetype=scala
autocmd FileType go,java,sql set colorcolumn=100
