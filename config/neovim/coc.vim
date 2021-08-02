set hidden
set updatetime=200

inoremap <silent><expr> <C-Space> coc#refresh()
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr>         <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)

nnoremap <silent> <Leader>c <Cmd>Telescope coc commands<CR>
nnoremap <silent> <C-]> <Cmd>Telescope coc definitions<CR>
nnoremap <silent> <A-CR> <Cmd>Telescope coc code_actions<CR>
nnoremap <silent> <Leader>la <Cmd>Telescope coc code_actions<CR>
nnoremap <silent> <Leader>lda <Cmd>Telescope coc file<CR>
nnoremap <silent> <Leader>ldd <Cmd>Telescope coc diagnostics<CR>
nnoremap <silent> <Leader>lds <Cmd>Telescope coc document_symbols<CR>
nnoremap <silent> <Leader>li <Cmd>Telescope coc implementations<CR>
nnoremap <silent> <Leader>lla <Cmd>Telescope coc line_code_actions<CR>
nnoremap <silent> <Leader>lt <Cmd>Telescope coc type_definitions<CR>
nnoremap <silent> <Leader>lwd <Cmd>Telescope coc workspace_diagnostics<CR>
nnoremap <silent> <Leader>lws <Cmd>Telescope coc workspace_symbols<CR>
nnoremap <silent> gr <Cmd>Telescope coc references<CR>

nnoremap <silent> K :call CocActionAsync('doHover')<CR>

nnoremap <Leader>lr <Plug>(coc-rename)
nnoremap <Leader>lf <Cmd>call CocAction('format')<CR>

nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

command! -nargs=0 Format :call CocAction('format')
