set showtabline=0

nnoremap z= <Cmd>Telescope spell_suggest<CR>

nmap <Leader><Tab>   <Cmd>Telescope buffers<CR>
nmap <Leader><S-Tab> <Cmd>Telescope tele_tabby list<CR>
nmap <Leader>/       <Cmd>Telescope current_buffer_fuzzy_find<CR>
nmap <Leader>?       <Cmd>Telescope live_grep<CR>
nmap <Leader>"       <Cmd>Telescope registers<CR>
nmap <Leader>f       <Cmd>Telescope find_files<CR>
nmap <Leader>j       <Cmd>Telescope jumplist<CR>
nmap <Leader>o       <Cmd>Telescope oldfiles<CR>

nmap <Leader>ld <Cmd>Telescope diagnostics bufnr=0<CR>
nmap <Leader>lD <Cmd>Telescope diagnostics<CR>

nmap <Leader>gC <Cmd>Telescope git_commits<CR>
nmap <Leader>gc <Cmd>Telescope git_bcommits<CR>
nmap <Leader>gf <Cmd>Telescope git_files<CR>

nmap <Leader>' <Cmd>Telescope neoclip<CR>

nmap <Leader>m <Cmd>Telescope vim_bookmarks current_file<CR>
nmap <Leader>M <Cmd>Telescope vim_bookmarks all<CR>

nmap <Leader>s <Cmd>Telescope luasnip<CR>
