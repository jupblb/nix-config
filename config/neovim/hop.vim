nnoremap <Leader><Space> :HopWord<CR>
augroup HopInitHighlight
  autocmd!
  autocmd VimEnter * highlight HopNextKey guifg=#cc241d gui=bold
  autocmd VimEnter * highlight HopNextKey1 guifg=#cc241d gui=bold
  autocmd VimEnter * highlight HopNextKey2 guifg=#cc241d
  autocmd VimEnter * highlight HopUnmatched guifg=#3c3836
augroup end
