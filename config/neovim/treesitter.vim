set foldexpr=nvim_treesitter#foldexpr()
set foldmethod=expr
set foldlevel=100

lua require'nvim-treesitter.configs'.setup {
  \   ensure_installed = "maintained",
  \   ignore_install = { "gdscript", "ocamllex" },
  \   indent = { enable = true },
  \   highlight = { enable = true, disable = { "yaml" } },
  \   refactor = {
  \     highlight_definitions = { enable = true },
  \     navigation = {
  \       enable = true,
  \       keymaps = { goto_definition_lsp_fallback = '<C-]>' }
  \     }
  \   }
  \ }
