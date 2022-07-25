require("zen-mode").setup({
    window = {
        options = {
            signcolumn = "no",
        },
        width = 120,
    },
    plugins = {
        kitty = {
            enabled = true,
            font = "+4",
        },
    },
})

vim.keymap.set('n', '<Leader><CR>', '<Cmd>ZenMode<CR>', { silent = true })
