local cmp = require('cmp')

cmp.setup({
    mapping = {
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete({}), { 'i', 'c' }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    preselect = cmp.PreselectMode.None,
    sources = cmp.config.sources({
        { name = 'nvim_lsp' }, { name = 'nvim_lsp_signature_help' },
        { name = 'path' }, { name = 'latex_symbols' },
    }),
    window = { documentation = cmp.config.window.bordered() }
})
