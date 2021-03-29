{ makeWrapper, neovim-unwrapped, tree-sitter }:

neovim-unwrapped.overrideAttrs(old: rec {
  buildInputs = old.buildInputs ++ [ makeWrapper tree-sitter ];
  postInstall = old.postInstall + ''
    wrapProgram $out/bin/nvim --prefix PATH : ${tree-sitter}/bin
  '';
  src         = builtins.fetchGit {
    ref = version;
    url = https://github.com/neovim/neovim.git;
  };
  version     = "nightly";
})
