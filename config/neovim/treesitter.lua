require('nvim-treesitter.configs').setup {
    indent = {enable = true},
    highlight = {enable = true, disable = {"yaml"}},
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
}
