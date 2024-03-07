local cmp = require('cmp')
local luasnip = require('luasnip')

local sources = cmp.config.sources({
    { name = 'treesitter' }, { name = 'async_path' },
    { name = 'latex_symbols' }, { name = 'fish' },
})

if vim.fn.getcwd():find('/google/src/') == nil then
    require('copilot').setup({
        panel = { enabled = false, },
        suggestion = { enabled = false, },
    })
    require('copilot_cmp').setup({})
    sources = cmp.config.sources({
        { name = 'treesitter' }, { name = 'copilot', }, { name = 'async_path' },
        { name = 'latex_symbols' }, { name = 'fish' },
    })
end

-- https://github.com/zbirenbaum/copilot-cmp?tab=readme-ov-file#tab-completion-configuration-highly-recommended
local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
        vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

cmp.setup({
    mapping = {
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete({}), { 'i', 'c' }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() and has_words_before() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    preselect = cmp.PreselectMode.None,
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    sources = sources,
    window = { documentation = cmp.config.window.bordered() }
})
