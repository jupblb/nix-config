local gruvbox_light = {}
local colors = {
  white        = '#fbf1c7',
  black        = '#3c3836',
  red          = '#9d0006',
  green        = '#79740e',
  blue         = '#076678',
  yellow       = '#af3a03',
  gray         = '#928374',
  darkgray     = '#ebdbb2',
  lightgray    = '#d5c4a1',
  inactivegray = '#a89984'
}

gruvbox_light.normal = {
  a = {bg = colors.gray, fg = colors.white, gui = 'bold'},
  b = {bg = colors.lightgray, fg = colors.black},
  c = {bg = colors.darkgray, fg = colors.gray}
}

gruvbox_light.insert = {
  a = {bg = colors.blue, fg = colors.white, gui = 'bold'},
  b = {bg = colors.lightgray, fg = colors.black},
  c = {bg = colors.lightgray, fg = colors.black}
}

gruvbox_light.visual = {
  a = {bg = colors.yellow, fg = colors.white, gui = 'bold'},
  b = {bg = colors.lightgray, fg = colors.black},
  c = {bg = colors.inactivegray, fg = colors.white}
}

gruvbox_light.replace = {
  a = {bg = colors.red, fg = colors.white, gui = 'bold'},
  b = {bg = colors.lightgray, fg = colors.black},
  c = {bg = colors.white, fg = colors.black}
}

gruvbox_light.command = {
  a = {bg = colors.green, fg = colors.white, gui = 'bold'},
  b = {bg = colors.lightgray, fg = colors.black},
  c = {bg = colors.inactivegray, fg = colors.white}
}

gruvbox_light.inactive = {
  a = {bg = colors.darkgray, fg = colors.gray, gui = 'bold'},
  b = {bg = colors.darkgray, fg = colors.gray},
  c = {bg = colors.darkgray, fg = colors.gray}
}

require('lualine').setup{
  extensions = { 'fugitive', 'fzf' }, --, 'nvim-tree' },
  options = { theme = gruvbox_light }
}
