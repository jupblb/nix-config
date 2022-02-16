local cmp = require('cmp')

local function tab_movement(movement)
    return function(fallback)
        if cmp.visible() then
            movement()
        else
            fallback()
        end
    end
end

cmp.setup({
    documentation = {
        border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'}
    },
    mapping = {
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<CR>'] = cmp.mapping.confirm({select = false}),
        ["<Tab>"] = tab_movement(cmp.select_next_item),
        ["<S-Tab>"] = tab_movement(cmp.select_prev_item)
    },
    preselect = cmp.PreselectMode.None,
    sources = cmp.config.sources({{name = 'nvim_lsp'}},
                                 {{name = 'nvim_lsp_signature_help'}},
                                 {{name = 'path'}}, {{name = 'buffer'}})
})
