local parser_install_dir = vim.fn.expand('$XDG_CACHE_HOME/nvim/parsers')

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
    parser_install_dir = parser_install_dir,
})

vim.opt.runtimepath:append(parser_install_dir)
vim.g.skip_ts_context_commentstring_module = true
