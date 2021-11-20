nmap <Leader><Tab> <Cmd>Telescope buffers<CR>
nmap <Leader>/     <Cmd>Telescope current_buffer_fuzzy_find<CR>
nmap <Leader>?     <Cmd>Telescope live_grep<CR>
nmap <Leader>"     <Cmd>Telescope registers<CR>
nmap <Leader>f     <Cmd>Telescope find_files<CR>
nmap <Leader>o     <Cmd>Telescope oldfiles<CR>

nmap <Leader>gb <Cmd>Telescope git_branches<CR>
nmap <Leader>gc <Cmd>lua delta_git_commits()<CR>
nmap <Leader>gC <Cmd>lua delta_git_bcommits({path=vim.fn.expand("%:p")})<CR>
nmap <Leader>gf <Cmd>Telescope git_files<CR>
nmap <Leader>gs <Cmd>lua delta_git_status()<CR>

nmap <Leader>ldd <Cmd>Telescope lsp_document_diagnostics<CR>
nmap <Leader>lwd <Cmd>Telescope lsp_workspace_diagnostics<CR>

nmap <Leader>' <Cmd>Telescope neoclip<CR>

nmap <Leader>m <Cmd>Telescope vim_bookmarks current_file<CR>
nmap <Leader>M <Cmd>Telescope vim_bookmarks all<CR>
