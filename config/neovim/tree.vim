let g:nvim_tree_auto_close = 1
let g:nvim_tree_disable_netrw = 0
let g:nvim_tree_git_hl = 1
let g:nvim_tree_gitignore = 1
let g:nvim_tree_group_empty = 1
let g:nvim_tree_hijack_netrw = 0
let g:nvim_tree_icon_padding = '  '
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "",
    \   'staged': "",
    \   'unmerged': "",
    \   'renamed': "",
    \   'untracked': "",
    \   'deleted': "",
    \   'ignored': ""
    \   },
    \ 'folder': {
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   },
    \   'lsp': {
    \     'hint': "",
    \     'info': "",
    \     'warning': "",
    \     'error': "",
    \   }
    \ }
let g:nvim_tree_lsp_diagnostics = 1
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 1,
    \ 'folder_arrows': 0,
    \ }
let g:nvim_tree_width = 42
let g:nvim_tree_width_allow_resize = 1

nnoremap <Leader>t :NvimTreeToggle<CR>
nnoremap <Leader>T :NvimTreeFindFile<CR>
