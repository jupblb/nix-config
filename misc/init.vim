set background=light
set clipboard+=unnamedplus
set ignorecase
set mouse=a
set nowrap
set number
set shell=bash
set smartcase
set termguicolors
set splitright
set nohlsearch

" Remap leader key to space
nnoremap <Space> <Nop>
let mapleader="\<Space>"

" Use spaces for indentation
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
autocmd FileType make set noexpandtab

" Colorscheme
let g:airline_theme = 'gruvbox'
let g:gruvbox_contrast_light = 'hard'
let g:gruvbox_italic = 1
colorscheme gruvbox
autocmd VimEnter * highlight clear Normal

" Airline
set noshowmode
let g:airline_powerline_fonts = 1

" Fzf
let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'] }

autocmd! FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=? -complete=dir GFiles
    \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

function! RipgrepFzf(query, fullscreen)
    let command_fmt =
        \ 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = { 'options': [
        \ '--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command
        \ ] }
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

nnoremap <Leader>/     :BLines<CR>
nnoremap <Leader><Tab> :Buffers<CR>
nnoremap <Leader>gf    :GFiles<CR>
nnoremap <Leader>f     :Files<CR>
nnoremap <Leader>h     :History<CR>
nnoremap <Leader>r     :RG<CR>

" glow.nvim
nmap <Leader>m :Glow<CR>

" nvim-lsp
set completeopt=menuone,noinsert,noselect
set shortmess+=c

lua << EOF
local nvim_lsp = require 'nvim_lsp'
nvim_lsp.bashls.setup {}
nvim_lsp.rnix.setup {}
EOF

autocmd Filetype java set omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype proto set omnifunc=v:lua.vim.lsp.omnifunc

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap <silent> <Leader>ld <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gd         <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD         <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> K          <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <Leader>li <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr         <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <Leader>lr <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gs         <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <Leader>lt <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gW         <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <Leader>lf <cmd>lua vim.lsp.buf.formatting()<CR>

" Ranger
nnoremap <Leader><CR> :RangerEdit<CR>

if filereadable(expand("~/.config/nvim/google.vim"))
 source ~/.config/nvim/google.vim
endif
