nmap <Leader><Space> <Cmd>HopWord<CR>
vmap <Leader><Space> <Cmd>HopWord<CR>

highlight HopNextKey guifg=#cc241d gui=bold
highlight HopNextKey1 guifg=#cc241d gui=bold
highlight HopNextKey2 guifg=#cc241d
highlight HopUnmatched guifg=#3c3836

lua require('hop').setup({create_hl_autocmd = false})
