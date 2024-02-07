require('ts_context_commentstring').setup({
    languages = {
        cpp = '// %s',
        dart = '// %s',
    },
})

require('nvim-treesitter.configs').setup({
    highlight = { enable = true, disable = { 'yaml' } },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<TAB>',
            node_incremental = '<TAB>',
            node_decremental = '<S-TAB>',
        }
    },
    matchup = { enable = true },
})

vim.g.skip_ts_context_commentstring_module = true

-- https://github.com/dhruvinsh/nvim/blob/bcd7cfb8a29886b2c90b1182629ce73dbf88f2d6/after/plugin/treesitter.lua#L115-L134
vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function(ev)
        local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(ev.buf))
        if 0 < size and size < 1024 * 1024 then
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            -- vim.opt_local.foldtext = "v:lua.vim.treesitter.foldtext()"
        end
    end,
})
