nmap gD         <Cmd>lua vim.lsp.buf.declaration()<CR>
nmap <C-]>      <Cmd>lua vim.lsp.buf.definition()<CR>
nmap gd         <Cmd>lua vim.lsp.buf.definition()<CR>
nmap <C-=>      <Cmd>lua vim.lsp.buf.format({async = true})<CR>
nmap <Leader>li <Cmd>lua vim.lsp.buf.incoming_calls()<CR>
nmap <Leader>lo <Cmd>lua vim.lsp.buf.outgoing_calls()<CR>
nmap <C-[>      <Cmd>lua vim.lsp.buf.references()<CR>
nmap grt        <Cmd>lua vim.lsp.buf.type_definition()<CR>
nmap gW         <Cmd>lua vim.lsp.buf.workspace_symbol()<CR>
