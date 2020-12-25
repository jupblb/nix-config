set foldexpr=nvim_treesitter#foldexpr()
set foldmethod=expr
set foldlevel=100

lua require'nvim-treesitter.configs'.setup {
  \   ensure_installed = "maintained",
  \   indent = { enable = true },
  \   highlight = { enable = true },
  \   refactor = {
  \     highlight_current_scope = { enable = true },
  \     highlight_definitions = { enable = true }
  \   }
  \ }

