lua require("trouble").setup {
  \    action_keys = { next = {}, previous = {} },
  \    signs = { other = '' }
  \  }

nnoremap <Leader>x <Cmd>TroubleToggle<CR>
nnoremap <Leader>q <Cmd>TroubleToggle quickfix<CR>
nnoremap <Leader>Q <Cmd>TroubleToggle loclist<CR>

autocmd Filetype Trouble nnoremap <buffer> j :lua require("trouble").next({skip_groups = true})<CR>
autocmd Filetype Trouble nnoremap <buffer> k :lua require("trouble").previous({skip_groups = true})<CR>
