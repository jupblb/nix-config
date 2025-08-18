local cmp = require('cmp')
local luasnip = require('luasnip')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

require('copilot').setup({
    panel      = { enabled = false, },
    suggestion = { enabled = false, },
})
require('copilot_cmp').setup({})

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
    experimental = { ghost_text = true },
    mapping      = {
        ['<C-u>']     = cmp.mapping.scroll_docs(-4),
        ['<C-d>']     = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>']      = cmp.mapping.confirm({ select = false }),
        ['<Tab>']     = cmp.mapping(function(fallback)
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
        ['<S-Tab>']   = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    preselect    = cmp.PreselectMode.None,
    snippet      = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    sources      = cmp.config.sources({
        { name = 'copilot', },
        { name = 'treesitter' },
        { name = 'async_path' },
    }),
    window       = { documentation = cmp.config.window.bordered() }
})

vim.lsp.config('*', {
    on_attach    = {
        function(client, _)
            if client.server_capabilities.completionProvider then
                cmp.setup.buffer({
                    sources = cmp.config.sources({
                        { name = 'copilot' }, { name = 'nvim_lsp' },
                        { name = 'nvim_lsp_signature_help' },
                        { name = 'async_path' },
                    }),
                })
            end
        end
    },
    capabilities = require('cmp_nvim_lsp').default_capabilities({}),
})
