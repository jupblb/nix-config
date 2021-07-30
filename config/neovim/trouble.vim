lua require("trouble").setup {}

nnoremap <Leader>x <Cmd>TroubleToggle<CR>
nnoremap <Leader>q <Cmd>TroubleToggle quickfix<CR>
nnoremap <Leader>Q <Cmd>TroubleToggle loclist<CR>

autocmd Filetype Trouble nnoremap <buffer> <C-n> :lua require("trouble").next({skip_groups = true})<CR>
autocmd Filetype Trouble nnoremap <buffer> <C-p> :lua require("trouble").previous({skip_groups = true})<CR>
