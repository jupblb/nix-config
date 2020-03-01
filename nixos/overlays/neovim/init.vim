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

"imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"inoremap <expr> <CR> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

nmap <silent> <Leader>[l <Plug>(coc-diagnostic-prev)
nmap <silent> <Leader>]l <Plug>(coc-diagnostic-next)

nmap <silent> <Leader>ld <Plug>(coc-definition)
nmap <silent> <Leader>lt <Plug>(coc-type-definition)
nmap <silent> <Leader>li <Plug>(coc-implementation)
nmap <silent> <Leader>lu <Plug>(coc-references)

nnoremap <silent> <Leader>lh :call <SID>show_documentation()<CR>

nmap <Leader>lr <Plug>(coc-rename)
nmap <Leader>lf :call CocAction('format')<CR>
nmap <leader>lx  <Plug>(coc-fix-current)

nnoremap <silent> <space>lst :<C-u>CocCommand metals.tvp<CR>
nnoremap <silent> <space>lsb :<C-u>CocCommand metals.tvp metalsBuild<CR>
nnoremap <silent> <space>lsc :<C-u>CocCommand metals.tvp metalsCompile<CR>
nnoremap <silent> <space>lsf :<C-u>CocCommand metals.revealInTreeView metalsBuild<CR>

nnoremap <silent> <Leader>la :<C-u>CocList diagnostics<CR>
nnoremap <silent> <Leader>le :<C-u>CocList extensions<cr>
nnoremap <silent> <Leader>lc :<C-u>CocList commands<cr>
nnoremap <silent> <Leader>lo :<C-u>CocList outline<cr>

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
nmap <Leader>g :Limelight!!<CR>:Goyo<CR>
xmap <Leader>g :Limelight!!<CR>:Goyo<CR>

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

" Other mappings
nnoremap <Leader>n :set invnumber<CR>:GitGutterToggle<CR>
nnoremap <Leader>d :bd<CR>
nnoremap <Leader>w :w<CR>

