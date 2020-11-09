set completeopt=menuone,noinsert,noselect
set shortmess+=c

imap     <silent> <C-Space> <Plug>(completion_trigger)
imap     <silent> <C-@>     <Plug>(completion_trigger)
inoremap <expr>   <Tab>     pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr>   <S-Tab>   pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr>   <CR>      pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

autocmd BufEnter * lua require'completion'.on_attach()

