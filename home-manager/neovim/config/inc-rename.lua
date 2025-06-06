require('inc_rename').setup({
    preview_empty_name = true,
    show_message = false,
})

vim.keymap.set('n', 'grn', function()
    return ':IncRename ' .. vim.fn.expand('<cword>')
end, { expr = true })
