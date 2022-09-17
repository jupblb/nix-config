require("zen-mode").setup({
    window = {
        options = {
            signcolumn = "no",
        },
        width = 120,
    },
    plugins = {
        diagnostics = { enabled = true },
    },
})

vim.keymap.set('n', '<Leader><CR>', '<Cmd>ZenMode<CR>', { silent = true })
