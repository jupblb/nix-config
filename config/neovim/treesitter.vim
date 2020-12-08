set foldexpr=nvim_treesitter#foldexpr()
set foldmethod=expr
set foldlevel=5

lua require'nvim-treesitter.configs'.setup {
  \   indent = { enable = true },
  \   highlight = { enable = true },
  \   refactor = {
  \     highlight_current_scope = { enable = true },
  \     highlight_definitions = { enable = true }
  \   }
  \ }

