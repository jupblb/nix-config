{ lib, neovim-unwrapped, tree-sitter, Security, stdenv }:

neovim-unwrapped.overrideAttrs(old: rec {
  buildInputs = old.buildInputs ++ [ tree-sitter ];
  src         = builtins.fetchGit {
    url = https://github.com/neovim/neovim.git;
    ref = version;
  };
  version     = "nightly";
})
