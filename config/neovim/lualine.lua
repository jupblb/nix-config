local gruvbox_light = {}
local colors = {
  bg     = '#fbf1c7',
  fg     = '#3c3836',
  red    = '#9d0006',
  green  = '#79740e',
  blue   = '#076678',
  orange = '#af3a03',
  gray   = '#928374',
  bg1    = '#ebdbb2',
  bg2    = '#d5c4a1',
  bg4    = '#a89984'
}

gruvbox_light.normal = {
  a = {bg = colors.gray, fg = colors.bg, gui = 'bold'},
  b = {bg = colors.bg2, fg = colors.fg},
  c = {bg = colors.bg1, fg = colors.gray}
}

gruvbox_light.insert = {
  a = {bg = colors.blue, fg = colors.bg, gui = 'bold'},
  b = {bg = colors.bg2, fg = colors.fg},
  c = {bg = colors.bg2, fg = colors.fg}
}

gruvbox_light.visual = {
  a = {bg = colors.orange, fg = colors.bg, gui = 'bold'},
  b = {bg = colors.bg2, fg = colors.fg},
  c = {bg = colors.bg4, fg = colors.bg}
}

gruvbox_light.replace = {
  a = {bg = colors.red, fg = colors.bg, gui = 'bold'},
  b = {bg = colors.bg2, fg = colors.fg},
  c = {bg = colors.bg, fg = colors.fg}
}

gruvbox_light.command = {
  a = {bg = colors.green, fg = colors.bg, gui = 'bold'},
  b = {bg = colors.bg2, fg = colors.fg},
  c = {bg = colors.bg4, fg = colors.bg}
}

gruvbox_light.inactive = {
  a = {bg = colors.bg1, fg = colors.gray, gui = 'bold'},
  b = {bg = colors.bg1, fg = colors.gray},
  c = {bg = colors.bg1, fg = colors.gray}
}

require('lualine').setup{
  extensions = { 'fugitive', 'nvim-tree' },
  options = { theme = gruvbox_light }
}
