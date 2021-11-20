require('luatab').setup({
    modified = function(bufnr)
        return vim.fn.getbufvar(bufnr, '&modified') == 1 and '  ' or ''
    end
})
