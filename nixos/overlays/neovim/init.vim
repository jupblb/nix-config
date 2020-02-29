set background=light
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

" Airline
let g:airline_powerline_fonts = 1
let g:airline_symbols_ascii = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#left_sep = ' '

" coc.nvim
set cmdheight=2
set hidden
set shortmess+=c
set signcolumn=yes
set updatetime=200

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()

inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

nmap <silent> <Leader>[ <Plug>(coc-diagnostic-prev)
nmap <silent> <Leader>] <Plug>(coc-diagnostic-next)

nmap <silent> <Leader>d <Plug>(coc-definition)
nmap <silent> <Leader>t <Plug>(coc-type-definition)
nmap <silent> <Leader>i <Plug>(coc-implementation)
nmap <silent> <Leader>u <Plug>(coc-references)

nnoremap <silent> <Leader>h :call <SID>show_documentation()<CR>

nmap <Leader>r <Plug>(coc-rename)
nmap <Leader>f :call CocAction('format')<CR>

nnoremap <silent> <Leader>a :<C-u>CocList diagnostics<CR>
nnoremap <silent> <Leader>e :<C-u>CocList extensions<cr>
nnoremap <silent> <Leader>c :<C-u>CocList commands<cr>
nnoremap <silent> <Leader>o :<C-u>CocList outline<cr>

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

" CtrlP
let g:ctrlp_map = '<Leader>p'
nnoremap <Leader>bl :CtrlPBuffer<CR>
set wildignore+=*.class,*.jar,*/target/*,*/.metals/*

" EasyMotion
let g:EasyMotion_do_mapping = 0
nmap <Leader><Leader> <Plug>(easymotion-overwin-f2)

" Gruvbox setup
let &t_ut=''
let g:airline_theme = 'gruvbox'
let g:gruvbox_contrast_light = 'hard'
colorscheme gruvbox

" LimeLight & Goyo
let g:goyo_width = 100
nmap <Leader>l :Limelight!!<CR>:Goyo<CR>
xmap <Leader>l :Limelight!!<CR>:Goyo<CR>

" Remap split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Tab navigation like Firefox.
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>
nnoremap <C-t>     :tabnew<CR>
nnoremap <C-w>     :tabclose<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>i
inoremap <C-w>     <Esc>:tabclose<CR>i

" Mappings
nnoremap <Leader>n :set invnumber<CR>:GitGutterToggle<CR>
nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>bw :w<CR>

