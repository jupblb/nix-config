nmap gD         <Cmd>lua vim.lsp.buf.declaration()<CR>
nmap gd         <Cmd>lua vim.lsp.buf.definition()<CR>
nmap <Leader>la <Cmd>lua vim.lsp.buf.code_action()<CR>
nmap g0         <Cmd>lua vim.lsp.buf.document_symbol()<CR>
nmap <C-=>      <Cmd>lua vim.lsp.buf.format({async = true})<CR>
nmap K          <Cmd>lua vim.lsp.buf.hover()<CR>
nmap gi         <Cmd>lua vim.lsp.buf.implementation()<CR>
nmap <Leader>li <Cmd>lua vim.lsp.buf.incoming_calls()<CR>
nmap <Leader>lo <Cmd>lua vim.lsp.buf.outgoing_calls()<CR>
nmap gr         <Cmd>lua vim.lsp.buf.references()<CR>
nmap <C-[>      <Cmd>lua vim.lsp.buf.references()<CR>
nmap <C-k>      <Cmd>lua vim.lsp.buf.signature_help()<CR>
nmap gs         <Cmd>lua vim.lsp.buf.signature_help()<CR>
nmap <Leader>lt <Cmd>lua vim.lsp.buf.type_definition()<CR>
nmap gW         <Cmd>lua vim.lsp.buf.workspace_symbol()<CR>
