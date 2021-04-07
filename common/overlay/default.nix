self: super: rec {
  ammonite-predef  = super.fetchurl {
    url    = https://git.io/vHaKQ;
    sha256 = "1kir3j5z3drkihx1hysdcmjaiacz840qpwbz70v4k62jr95mz3jp";
  };
  chromium-wayland = super.callPackage ./chromium-wayland/default.nix {};
  emacs-wrapped    = super.callPackage ./emacs {};
  fishPlugins      = import ./fish { inherit (super) callPackage; };
  lf               = super.callPackage ./lf { lf = super.lf; };
  lf-previewer     = super.callPackage ./lf/previewer.nix {};
  htop             = super.callPackage ./htop { htop = super.htop; };
  neovim-nightly   = super.callPackage ./neovim {};
  pragmata-pro     = super.callPackage ./pragmata-pro {};
  vimPlugins       = super.vimPlugins // {
    lf-vim = super.callPackage ./neovim/lf-vim.nix {
      inherit (super.vimPlugins) lf-vim vim-bbye;
    };
  };
}
