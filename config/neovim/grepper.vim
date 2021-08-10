runtime plugin/grepper.vim

let g:grepper.rg.grepprg .= ' -a -S'
let g:grepper.tools = ['git', 'grep', 'rg']

nnoremap <Leader>rb :Grepper -buffer -noquickfix -tool rg<CR>
nnoremap <Leader>rB :Grepper -buffers -tool rg<CR>
nnoremap <Leader>rr :Grepper -tool rg<CR>
nnoremap <Leader>rw :Grepper -buffer -cword -noquickfix -tool rg<CR>
nnoremap <Leader>rW :Grepper -buffers -cword -tool rg<CR>
