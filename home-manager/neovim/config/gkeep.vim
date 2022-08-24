let g:gkeep_icons = {
      \ 'home': ' ',
      \ 'label': ' ',
      \ 'list': ' ',
      \ 'note': ' ',
      \ 'search': ' ',
      \ }
let g:gkeep_sync_archived = 1
let g:gkeep_sync_dir = "~/Documents/keep"
let g:gkeep_width = 42

nmap <Leader>kO <Cmd>GkeepEnter<CR>
nmap <Leader>kC <Cmd>GkeepClose<CR>
nmap <Leader>kK <Cmd>GkeepToggle<CR>
nmap <Leader>kK <Cmd>Telescope gkeep<CR>
nmap <Leader>kn <Cmd>GkeepNew<CR>
nmap <Leader>ks <Cmd>GkeepSync<CR>
nmap <Leader>kS <Cmd>GkeepRefresh<CR>
nmap <Leader>kx <Cmd>GkeepCheck<CR>
nmap <Leader>kX <Cmd>GkeepClearChecked<CR>

lua require('telescope').load_extension('gkeep')
