local function lsp_status() return require('lsp-status').status() end
local function metals_status() return vim.g["metals_status"] or "" end

require('lualine').setup({
    extensions = {'nvim-tree', 'quickfix'},
    options = {component_separators = '|', section_separators = ''},
    sections = {
        lualine_b = {
            {'branch', icon = ''}, {
                'diff',
                diff_color = {
                    added = {fg = '#000000'},
                    modified = {fg = '#000000'},
                    removed = {fg = '#000000'}
                },
                symbols = {added = ' ', modified = ' ', removed = ' '}
            }
        },
        lualine_c = {{'filename', path = 1}},
        lualine_x = {lsp_status, metals_status},
        lualine_y = {
            'SleuthIndicator', 'encoding', {'filetype', colored = false}
        },
        lualine_z = {'progress', 'location'}
    }
})
