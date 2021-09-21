self: super: with super; {
  ammonite     = ammonite // {
    predef = pkgs.fetchurl {
      url    = https://git.io/vHaKQ;
      sha256 = "1kir3j5z3drkihx1hysdcmjaiacz840qpwbz70v4k62jr95mz3jp";
    };
  };
  emanote      =
    let url = "https://github.com/srid/emanote/archive/master.tar.gz";
    in (import (builtins.fetchTarball url)).default;
  fish-plugins = import ./fish/plugins { inherit (super) callPackage; };
  htop         = callPackage ./htop { htop = super.htop; };
  lf           = callPackage ./lf { lf = super.lf; };
  pragmata-pro = callPackage ./pragmata-pro {};
  ripgrep               =
    let rg_12 = builtins.fetchurl
      https://raw.githubusercontent.com/NixOS/nixpkgs/85f96822a05180cbfd5195e7034615b427f78f01/pkgs/tools/text/ripgrep/default.nix;
    in callPackage rg_12 { inherit (darwin.apple_sdk.frameworks) Security; };
  vimPlugins   = vimPlugins // {
    luatab-nvim = callPackage ./neovim/luatab.nix {};
    venn-nvim   = callPackage ./neovim/venn.nix {};
  };
  zk           = callPackage ./zk.nix {};
}
