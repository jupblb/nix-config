runtime plugin/grepper.vim

let g:grepper.rg.grepprg .= ' -a -S'
let g:grepper.tools = ['git', 'grep', 'rg']

nmap <Leader>rb :Grepper -buffer -noquickfix -tool rg<CR>
nmap <Leader>rB :Grepper -buffers -tool rg<CR>
nmap <Leader>rr :Grepper -tool rg<CR>
nmap <Leader>rw :Grepper -buffer -cword -noquickfix -tool rg<CR>
nmap <Leader>rW :Grepper -buffers -cword -tool rg<CR>
