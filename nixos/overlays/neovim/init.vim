" Enable true colors
set t_Co=256
set termguicolors

" Set background
set background=light

" Some language servers have issues with backup files
set nobackup
set nowritebackup

set updatetime=200

" Use bash
set shell=bash

" coc.nvim
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
nmap <silent> <Leader>d <Plug>(coc-definition)
nmap <silent> <Leader>t <Plug>(coc-type-definition)
nmap <silent> <Leader>i <Plug>(coc-implementation)
nmap <silent> <Leader>u <Plug>(coc-references)
nmap <Leader>r <Plug>(coc-rename)
nnoremap <silent> K :call <SID>show_documentation()<CR>
autocmd CursorHold * silent call CocActionAsync('highlight')
xmap <Leader>f <Plug>(coc-format-selected)
nmap <Leader>f <Plug>(coc-format-selected)
nnoremap <silent> <Leader>a :<C-u>CocList diagnostics<CR>
nnoremap <silent> <Leader>e :<C-u>CocList extensions<cr>
nnoremap <silent> <Leader>c :<C-u>CocList commands<cr>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

