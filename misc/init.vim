set background=light
set clipboard+=unnamedplus
set ignorecase
set mouse=a
set nowrap
set number
set shell=bash
set smartcase
set termguicolors

" Remap leader key to space
nnoremap <Space> <Nop>
let mapleader="\<Space>"

" Use spaces for indentation
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
autocmd FileType make noexpandtab

" Remap split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Other mappings
nnoremap <Leader>d :bd<CR>
nnoremap <Leader>n :set invnumber<CR>:SignifyToggle<CR>

" Colorscheme
let g:airline_theme = 'gruvbox'
let g:gruvbox_contrast_light = 'hard'
let g:gruvbox_italic = 1
colorscheme gruvbox

" Airline
set noshowmode
let g:airline_symbols_ascii = 1
let g:webdevicons_enable_airline_statusline = 0

" coc.nvim
set cmdheight=2
set hidden
set shortmess+=c
set signcolumn=yes
set updatetime=200

inoremap <expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <c-space> coc#refresh()
inoremap <expr> <CR> complete_info()["selected"] != "-1" ?
  \ "\<C-y>" : "\<C-g>u\<CR>"

nmap     <Leader>ld <Plug>(coc-definition)
nmap     <Leader>lt <Plug>(coc-type-definition)
nmap     <Leader>li <Plug>(coc-implementation)
nmap     <Leader>lu <Plug>(coc-references)
nmap     <Leader>lr <Plug>(coc-rename)
nmap     <Leader>lf :call CocAction('format')<CR>
nnoremap <Leader>lh :call <SID>show_documentation()<CR>

autocmd CursorHold * silent call CocActionAsync('highlight')

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd VimEnter * highlight clear Normal

" Denite
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> p
    \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> <Esc>
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> i
    \ denite#do_map('open_filter_buffer')
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
    imap <silent><buffer> <Esc> <Plug>(denite_filter_quit)
endfunction

call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
call denite#custom#var('grep', {
    \ 'command': ['rg'],
    \ 'default_opts': ['-i', '--vimgrep', '--no-heading'],
    \ 'pattern_opt': ['--regexp'],
    \ 'separator': ['--']
    \ })

call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
    \ ['git', 'ls-files', '-co', '--exclude-standard'])

call denite#custom#option('default', {
    \ 'auto_resize': 1,
    \ 'winheight': 15,
    \ 'preview_height': 30,
    \ })

nnoremap <Leader>/  :Denite line -start-filter=true<CR>
nnoremap <Leader>b  :Denite buffer<CR>
nnoremap <Leader>ff :DeniteProjectDir file<CR>
nnoremap <Leader>fg :DeniteProjectDir file/rec/git -start-filter=true<CR>
nnoremap <Leader>fr :DeniteProjectDir file/rec -start-filter=true<CR>
nnoremap <Leader>h  :Denite file/old<CR>
nnoremap <Leader>r  :DeniteProjectDir grep<CR>

" EasyMotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
nmap <Leader><Leader> <Plug>(easymotion-overwin-f)

" Goyo
let g:goyo_width = 200
nmap <Leader>` :Goyo<CR>:hi clear Normal<CR>

" Ranger
nnoremap <Leader><CR> :RangerEdit<CR>

" Startify
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction

