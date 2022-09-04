local diagnostics_active = true

vim.keymap.set('n', '<Leader>d', function()
    if diagnostics_active then
        vim.diagnostic.disable()
    else
        vim.diagnostic.enable()
    end
    diagnostics_active = not diagnostics_active
end)
