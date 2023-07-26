local parser_install_dir = vim.fn.expand('$XDG_CACHE_HOME/nvim/parsers')

require('nvim-treesitter.configs').setup({
    auto_install = true,
    context_commentstring = {
        enable = true,
        config = { dart = '// %s' },
    },
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
    refactor = {
        highlight_definitions = { enable = true },
        navigation = { enable = true, keymaps = { goto_definition = 'gd' } }
    },
})

vim.opt.runtimepath:append(parser_install_dir)
