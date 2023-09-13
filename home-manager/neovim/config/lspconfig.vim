autocmd ColorScheme * highlight NormalFloat guibg=#fbf1c7
autocmd ColorScheme * highlight FloatBorder guifg=#282828 guibg=#fbf7c7
autocmd ColorScheme * highlight LspReferenceText guibg=#d9d87f

autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()

nmap gD          <Cmd>lua vim.lsp.buf.declaration()<CR>
nmap <C-]>       <Cmd>lua vim.lsp.buf.definition()<CR>
nmap <Leader>la  <Cmd>lua vim.lsp.buf.code_action()<CR>
nmap <Leader>lv  <Cmd>lua vim.lsp.buf.document_symbol()<CR>
nmap <Leader>=   <Cmd>lua vim.lsp.buf.format({async = true})<CR>
nmap <Leader>lf  <Cmd>lua vim.lsp.buf.format({async = true})<CR>
nmap K           <Cmd>lua vim.lsp.buf.hover()<CR>
nmap <Leader>li  <Cmd>lua vim.lsp.buf.implementation()<CR>
nmap <Leader>lci <Cmd>lua vim.lsp.buf.incoming_calls()<CR>
nmap <Leader>lco <Cmd>lua vim.lsp.buf.outgoing_calls()<CR>
nmap gr          <Cmd>lua vim.lsp.buf.references()<CR>
nmap <C-[>       <Cmd>lua vim.lsp.buf.references()<CR>
nmap gs          <Cmd>lua vim.lsp.buf.signature_help()<CR>
nmap <Leader>ls  <Cmd>lua vim.lsp.buf.signature_help()<CR>
nmap <Leader>lt  <Cmd>lua vim.lsp.buf.type_definition()<CR>
nmap <Leader>lws <Cmd>lua vim.lsp.buf.workspace_symbol()<CR>
