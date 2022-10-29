nmap <Leader>z[ <Cmd>ZkBacklinks<CR>
nmap <Leader>z] <Cmd>ZkLinks<CR>
nmap <Leader>zi <Cmd>ZkIndex { force = true }<CR>

nmap <Leader>zo <Cmd>ZkNotes { sort = { 'modified' } }<CR>
nmap <Leader>zz <Cmd>ZkNotes { sort = { 'modified' } }<CR>

nmap <Leader>znb <Cmd>ZkNew {
    \   dir   = 'blog',
    \   group = 'blog',
    \   title = vim.fn.input('Title: ')
    \ }<CR>
nmap <Leader>zng <Cmd>ZkNew {
    \   dir   = 'google',
    \   group = 'google',
    \   title = vim.fn.input('Title: ')
    \ }<CR>
nmap <Leader>znn <Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>
nmap <Leader>zns <Cmd>ZkNew {
    \   dir   = 'swps',
    \   group = 'swps',
    \   title = vim.fn.input('Title: ')
    \ }<CR>

lua require("zk").setup({})
