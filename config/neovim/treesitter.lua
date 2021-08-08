require('nvim-treesitter.configs').setup {
    indent = {enable = true},
    highlight = {enable = true, disable = {"yaml"}},
    refactor = {
        highlight_definitions = {enable = true},
        navigation = {enable = true, keymaps = {goto_definition = 'gd'}}
    }
}

vim.api.nvim_command(
    "autocmd VimEnter * highlight TSDefinitionUsage guibg=#d9d87f")
