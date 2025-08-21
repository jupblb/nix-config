require('nvim-treesitter.configs').setup({
    highlight             = { enable = true },
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

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
