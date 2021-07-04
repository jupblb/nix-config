{ neovim-unwrapped }:

neovim-unwrapped.overrideAttrs(_: rec {
  src     = builtins.fetchGit {
    ref = version;
    url = https://github.com/neovim/neovim.git;
  };
  version = "nightly";
})
