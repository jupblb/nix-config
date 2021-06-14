{ neovim-unwrapped, tree-sitter }:

neovim-unwrapped.overrideAttrs(old: rec {
  buildInputs = old.buildInputs ++ [ tree-sitter ];
  src         = builtins.fetchGit {
    ref = version;
    url = https://github.com/neovim/neovim.git;
  };
  version     = "nightly";
})
