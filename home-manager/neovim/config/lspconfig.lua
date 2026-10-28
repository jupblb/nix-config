local default_servers = { 'bashls', 'fish_lsp'  }
for _, lsp in ipairs(default_servers) do vim.lsp.enable(lsp) end
