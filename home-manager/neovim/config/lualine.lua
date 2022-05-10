require('lualine').setup({
    extensions = { 'nvim-tree', 'quickfix' },
    options = {
        component_separators = '|',
        section_separators = '',
        globalstatus = true
    },
    sections = {
        lualine_b = { 'tabs' },
        lualine_c = {
            {
                'filename',
                path = 1,
                symbols = { modified = ' ', readonly = ' ' }
            }
        },
        lualine_x = {
            {
                'diagnostics',
                colored = false,
                sources = { 'nvim_diagnostic', 'nvim_lsp' },
                symbols = {
                    error = ' ',
                    warn = ' ',
                    info = ' ',
                    hint = ' '
                }
            }
        },
        lualine_y = {
            'SleuthIndicator', 'filesize', { 'filetype', colored = false },
            'branch'
        },
        lualine_z = { 'progress', 'location' }
    }
})
