{ nvim-treesitter, tree-sitter }:

let
  flaky    = [ "tree-sitter-bash-grammar" "tree-sitter-yaml-grammar" ];
  grammars = builtins.filter (g: !(builtins.elem g.pname flaky))
    tree-sitter.allGrammars;
in nvim-treesitter.withPlugins(_: grammars)
