vim.lsp.config('harper_ls', {
    settings = {
        ["harper-ls"] = {
            linters = {
                SentenceCapitalization = false,
                SpellCheck             = false
            }
        }
    },
})

local default_servers = {
    'bashls', 'fish_lsp', 'harper_ls', 'marksman', 'nil_ls'
}
for _, lsp in ipairs(default_servers) do vim.lsp.enable(lsp) end
