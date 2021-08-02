require('lualine').setup {
  extensions = { 'fugitive', 'nvim-tree', 'quickfix' },
  options = {
    component_separators = '|',
    section_separators = '',
    theme = 'gruvbox_light'
  },
  sections = {
    lualine_b = {'branch', {
      'diff',
      color_added = '#8ec07c',
      color_modified = '#f9f5d7',
      color_removed = '#fb4934'
    }},
    lualine_c = { {'filename', path = 1 } },
    lualine_x = { { 'diagnostics', sources = { 'coc' } } },
    lualine_y = {'encoding', { 'filetype', colored = false } },
    lualine_z = {'progress', 'location'}
  }
}
