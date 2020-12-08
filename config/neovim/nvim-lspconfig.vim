packadd nvim-lspconfig

lua require'lspconfig'.bashls.setup{}
lua require'lspconfig'.rnix.setup{}

if executable("pyls")
  setlocal omnifunc=v:lua.vim.lsp.omnifunc
  lua require'lspconfig'.pyls.setup{}
endif

nnoremap <silent> <Leader>la <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <c-]>      <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <Leader>ld <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <Leader>lf <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> K          <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gr         <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <Leader>lr <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gs         <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <Leader>lw <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

