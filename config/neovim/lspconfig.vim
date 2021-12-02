autocmd ColorScheme * highlight NormalFloat guibg=#fbf1c7
autocmd ColorScheme * highlight FloatBorder guifg=#282828 guibg=#fbf7c7

nmap gD          <Cmd>lua vim.lsp.buf.declaration()<CR>
nmap <C-]>       <Cmd>lua vim.lsp.buf.definition()<CR>
nmap <Leader>lD  <Cmd>lua vim.lsp.buf.definition()<CR>
nmap <Leader>lds <Cmd>lua vim.lsp.buf.document_symbol()<CR>
nmap <Leader>=   <Cmd>lua vim.lsp.buf.formatting()<CR>
nmap <Leader>lf  <Cmd>lua vim.lsp.buf.formatting()<CR>
nmap K           <Cmd>lua vim.lsp.buf.hover()<CR>
nmap <Leader>li  <Cmd>lua vim.lsp.buf.implementation()<CR>
nmap <Leader>lci <Cmd>lua vim.lsp.buf.incoming_calls()<CR>
nmap <Leader>lco <Cmd>lua vim.lsp.buf.outgoing_calls()<CR>
nmap gr          <Cmd>lua vim.lsp.buf.references()<CR>
nmap <Leader>lr  <Cmd>lua vim.lsp.buf.rename()<CR>
nmap gs          <Cmd>lua vim.lsp.buf.signature_help()<CR>
nmap <Leader>ls  <Cmd>lua vim.lsp.buf.signature_help()<CR>
nmap <Leader>lt  <Cmd>lua vim.lsp.buf.type_definition()<CR>
nmap <Leader>lws <Cmd>lua vim.lsp.buf.workspace_symbol()<CR>

