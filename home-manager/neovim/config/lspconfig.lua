local default_servers = { 'bashls', 'marksman', 'nil_ls' }
for _, lsp in ipairs(default_servers) do vim.lsp.enable(lsp) end
