set hidden
set updatetime=200

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

command! -nargs=0 Format :call CocAction('format')

inoremap <silent><expr> <C-Space> coc#refresh()
inoremap <silent><expr> <CR>
  \ pumvisible() ? coc#_select_confirm() : 
  \ "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : coc#refresh()
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> <Leader>c <Cmd>Telescope coc commands<CR>
nmap <silent> <C-]> <Cmd>Telescope coc definitions<CR>
nmap <silent> <A-CR> <Cmd>Telescope coc code_actions<CR>
nmap <silent> <Leader>la <Cmd>CocAction<CR>
nmap <silent> <Leader>lda <Cmd>Telescope coc file<CR>
nmap <silent> <Leader>ldd <Cmd>Telescope coc diagnostics<CR>
nmap <silent> <Leader>lds <Cmd>Telescope coc document_symbols<CR>
nmap <silent> <Leader>li <Cmd>Telescope coc implementations<CR>
nmap <silent> <Leader>lla <Cmd>Telescope coc line_code_actions<CR>
nmap <silent> <Leader>lt <Cmd>Telescope coc type_definitions<CR>
nmap <silent> <Leader>lwd <Cmd>Telescope coc workspace_diagnostics<CR>
nmap <silent> <Leader>lws <Cmd>Telescope coc workspace_symbols<CR>
nmap <silent> gr <Cmd>Telescope coc references<CR>

nmap <silent> K :call CocActionAsync('doHover')<CR>

nmap <Leader>lr <Plug>(coc-rename)
nmap <Leader>lf <Cmd>call CocAction('format')<CR>
