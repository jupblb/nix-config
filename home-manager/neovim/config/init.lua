local diagnostics_active = true

vim.keymap.set('n', '<Leader>d', function()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
        vim.diagnostic.show()
    else
        vim.diagnostic.hide()
    end
end)
