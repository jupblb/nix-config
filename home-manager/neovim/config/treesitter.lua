require('nvim-treesitter.configs').setup({
    highlight             = { enable = true, disable = { 'yaml' } },
    incremental_selection = {
        enable  = true,
        keymaps = {
            init_selection   = '<TAB>',
            node_incremental = '<TAB>',
            node_decremental = '<S-TAB>',
        }
    },
    matchup               = { enable = true },
})

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
