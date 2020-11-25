{ neovim-unwrapped, tree-sitter }:

neovim-unwrapped.overrideAttrs(old: rec {
  buildInputs = old.buildInputs ++ [ tree-sitter ];
  src         = builtins.fetchGit {
    url = https://github.com/neovim/neovim.git;
    ref = version;
  };
  version     = "nightly";
})
