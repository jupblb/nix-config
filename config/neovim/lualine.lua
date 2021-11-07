local gps = require('nvim-gps')

gps.setup({})

require('lualine').setup {
    extensions = {'fugitive', 'nvim-tree', 'quickfix'},
    options = {
        component_separators = '|',
        section_separators = '',
        theme = 'gruvbox_light'
    },
    sections = {
        lualine_b = {
            'branch', {
                'diff',
                diff_color = {
                    added = { fg = '#79740e' },
                    modified = { fg = '#f9f5d7' },
                    removed = { fg = '#fb4934' },
                },
                symbols = {added = ' ', modified = ' ', removed = ' '}
            }
        },
        lualine_c = {
            {'filename', path = 1},
            {gps.get_location, condition = gps.is_available}
        },
        lualine_x = {
            {
                'diagnostics',
                diagnostics_color = {
                    error = { fg = '#cc241d' },
                    hint = { fg = '#98971a' },
                    info = { fg = '#7c6f64' },
                    warn = { fg = '#d79921' },
                },
                sources = {'coc'},
                symbols = {
                    error = ' ',
                    warn = ' ',
                    info = ' ',
                    hint = ' '
                }
            }
        },
        lualine_y = {
            'SleuthIndicator', 'encoding', {'filetype', colored = false}
        },
        lualine_z = {'progress', 'location'}
    }
}
