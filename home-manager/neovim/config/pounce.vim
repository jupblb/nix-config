" https://github.com/rlane/pounce.nvim#usage
nmap s <cmd>Pounce<CR>
nmap S <cmd>PounceRepeat<CR>
vmap s <cmd>Pounce<CR>
omap gs <cmd>Pounce<CR>

lua require('pounce').setup({multi_window = false})
