require('nvim-treesitter.configs').setup({
    context_commentstring = {enable = true},
    highlight = {enable = true, disable = {"go", "yaml"}},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<CR>",
            node_incremental = "<TAB>",
            node_decremental = "<S-TAB>"
        }
    },
    indent = {enable = true},
    matchup = {enable = true},
    refactor = {
        highlight_definitions = {enable = true},
        navigation = {enable = true, keymaps = {goto_definition = 'gd'}}
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner"
            }
        }
    }
})
