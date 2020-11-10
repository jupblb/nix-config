{ lib, neovim-unwrapped, tree-sitter, Security, stdenv }:

let tree-sitter' = tree-sitter.overrideAttrs(old: rec {
  buildInputs = old.buildInputs ++ lib.optionals stdenv.isDarwin [ Security ];
  cargoSha256 = "sha256-fonlxLNh9KyEwCj7G5vxa7cM/DlcHNFbQpp0SwVQ3j4=";
  meta        = old.meta // { broken = false; };
  postInstall = "PREFIX=$out make install";
  sha256      = "sha256-uQs80r9cPX8Q46irJYv2FfvuppwonSS5HVClFujaP+U=";
  src         = old.src // { version = version; };
  version     = "0.17.3";
});
in neovim-unwrapped.overrideAttrs(old: rec {
  buildInputs = old.buildInputs ++ [ tree-sitter' ];
  src         = builtins.fetchGit {
    url = https://github.com/neovim/neovim.git;
    ref = version;
  };
  version     = "nightly";
})
