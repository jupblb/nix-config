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
set virtualedit=all
set wrap

let g:markdown_fenced_languages = [
  \    'c', 'cpp', 'css', 'java', 'go', 'javascript', 'js=javascript',
  \    'json', 'python', 'sh', 'typescript', 'yaml'
  \  ]

map q: <Nop>
nnoremap Q <Nop>
nnoremap <Space> <Nop>
map <Space> <Leader>
map gf <Cmd>e <cfile><CR>

autocmd BufRead,BufNewFile *.fish set filetype=fish
autocmd BufRead,BufNewFile *.nix set filetype=nix
autocmd BufRead,BufNewFile *.sc set filetype=scala

autocmd FileType go,java,sql set colorcolumn=100
autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd FileType markdown set conceallevel=2
autocmd FileType scss setl iskeyword+=@-@
