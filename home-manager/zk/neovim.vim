nmap <Leader>z[ <Cmd>ZkBacklinks<CR>
nmap <Leader>z] <Cmd>ZkLinks<CR>
nmap <Leader>zi <Cmd>ZkIndex {force = true}<CR>
nmap <Leader>zn <Cmd>ZkNew {
    \     dir = vim.fn.expand('%:p:h'),
    \     title = vim.fn.input('Title: ')
    \ }<CR>
nmap <Leader>zo <Cmd>ZkNotes { sort = { 'modified' } }<CR>

vmap <Leader>zn <Cmd>ZkNew { dir = vim.fn.expand('%:p:h') }<CR>

lua require("zk").setup({})
