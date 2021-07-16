require('lualine').setup {
  extensions = { 'fugitive', 'nvim-tree', 'quickfix' },
  options = {
    component_separators = '|',
    section_separators = '',
    theme = 'gruvbox_light'
  },
  sections = {
    lualine_b = {'branch', 'diff'},
    lualine_x = { require('lsp-status').status },
    lualine_y = {'encoding', 'filetype'},
    lualine_z = {'progress', 'location'}
  }
}
