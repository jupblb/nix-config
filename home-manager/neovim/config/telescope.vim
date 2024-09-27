set showtabline=0

nnoremap z= <Cmd>Telescope spell_suggest<CR>

nmap <Leader><Tab>   <Cmd>Telescope buffers sort_mru=true<CR>
nmap <Leader>/       <Cmd>Telescope current_buffer_fuzzy_find<CR>
nmap <Leader>ld      <Cmd>Telescope diagnostics bufnr=0<CR>
nmap <Leader>lD      <Cmd>Telescope diagnostics<CR>
nmap <Leader>e       <Cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>
nmap <Leader>f       <Cmd>Telescope find_files<CR>
nmap <Leader>j       <Cmd>Telescope jumplist<CR>
nmap <Leader>?       <Cmd>Telescope live_grep<CR>
nmap <Leader>`       <Cmd>Telescope marks<CR>
nmap <Leader>o       <Cmd>Telescope oldfiles cwd_only=true<CR>
nmap <Leader><Space> <Cmd>Telescope pickers<CR>
nmap <Leader>"       <Cmd>Telescope registers<CR>

autocmd User TelescopePreviewerLoaded setlocal wrap
