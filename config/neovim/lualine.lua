require('lualine').setup {
  extensions = { 'fugitive', 'nvim-tree', 'quickfix' },
  options = { theme = 'gruvbox_light' },
  sections = { lualine_x = {'encoding', 'filetype'} }
}
