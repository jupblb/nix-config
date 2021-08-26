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
                color_added = '#79740e',
                color_modified = '#f9f5d7',
                color_removed = '#fb4934'
            }
        },
        lualine_c = {
            { 'filename', path = 1 },
            { gps.get_location, condition = gps.is_available }
        },
        lualine_x = {
            {
                'diagnostics',
                color_error = '#cc241d',
                color_warn = '#d79921',
                color_info = '#7c6f64',
                color_hint = '#98971a',
                sources = {'coc'}
            }
        },
        lualine_y = {'encoding', {'filetype', colored = false}},
        lualine_z = {'progress', 'location'}
    }
}
