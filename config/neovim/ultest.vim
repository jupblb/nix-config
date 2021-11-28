let g:ultest_fail_sign = ' '
let g:ultest_not_run_sign = ' '
let g:ultest_pass_sign = ' '
let g:ultest_running_sign = ' '
let g:ultest_use_pty = 1

autocmd VimEnter * highlight UltestPass ctermfg=Green guifg=#98971a
autocmd VimEnter * highlight UltestFail ctermfg=Red guifg=#cc241d
autocmd VimEnter * highlight UltestRunning ctermfg=Yellow guifg=#d79921
autocmd VimEnter * highlight UltestBorder ctermfg=Red guifg=#cc241d
autocmd VimEnter * highlight UltestSummaryInfo ctermfg=cyan guifg=#458588 gui=bold cterm=bold

nmap <Leader>ut <Cmd>Ultest<CR>
nmap <Leader>ul <Cmd>UltestLast<CR>
nmap <Leader>un <Cmd>UltestNearest<CR>
nmap <Leader>ux <Cmd>UltestStop<CR>
nmap <Leader>us <Cmd>UltestSummary<CR>
