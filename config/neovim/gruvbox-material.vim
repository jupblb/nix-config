set background=light
set termguicolors

let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_diagnostic_text_highlight = 1
let g:gruvbox_material_diagnostic_virtual_text = 'colored'
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_palette = 'original'

colorscheme gruvbox-material

autocmd VimEnter * highlight CursorLine guibg=bg
autocmd VimEnter * highlight LineNr guifg=#d5c4a1
autocmd VimEnter * highlight clear Normal
