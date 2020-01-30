" Enable true colors
set t_Co=256
set termguicolors

" Set background
set background=light

" Use bash
set shell=bash

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

nnoremap <silent> <Leader>k :call <SID>show_documentation()<CR>

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

" Airline
let g:airline_powerline_fonts = 1
let g:airline_symbols_ascii = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#left_sep = ' '

" EasyMotion
let g:EasyMotion_do_mapping = 0
nmap <Leader><Leader> <Plug>(easymotion-overwin-f2)
