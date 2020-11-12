set foldexpr=nvim_treesitter#foldexpr()
set foldmethod=expr
set foldlevel=5

lua <<EOF
require'nvim-treesitter.configs'.setup {
  indent = { enable = true },
  highlight = { enable = true }
}
EOF

