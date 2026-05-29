vim.api.nvim_create_autocmd('FileType', {
    callback = function(args) pcall(vim.treesitter.start, args.buf) end,
})

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'

vim.keymap.set('n', '<Tab>',   'van', { remap = true })
vim.keymap.set('x', '<Tab>',   'an',  { remap = true })
vim.keymap.set('x', '<S-Tab>', 'in',  { remap = true })
