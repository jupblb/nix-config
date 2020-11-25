autocmd! FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

nnoremap <Leader><Tab> :Buffers<CR>
nnoremap <Leader>f     :Files<CR>
nnoremap <Leader>h     :History<CR>
nnoremap <Leader>s     :Rg<CR>

