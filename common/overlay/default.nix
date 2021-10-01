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
  lf           = callPackage ./lf { lf = super.lf; };
  pragmata-pro = callPackage ./pragmata-pro {};
  vimPlugins   = vimPlugins // {
    luatab-nvim = callPackage ./neovim/luatab.nix {};
    venn-nvim   = callPackage ./neovim/venn.nix {};
  };
  zk           = callPackage ./zk.nix {};
}
