self: super: rec {
  chromium-wayland = super.callPackage ./chromium-wayland/default.nix {};
  emacs-wrapped    = super.callPackage ./emacs {};
  fishPlugins      = import ./fish { inherit (super) callPackage; };
  htop             = super.callPackage ./htop { htop = super.htop; };
  neovim-nightly   = super.callPackage ./neovim {};
  pragmata-pro     = super.callPackage ./pragmata-pro {};
  ranger           = super.callPackage ./ranger { ranger = super.ranger; };
  vimPlugins       = super.vimPlugins // {
    ranger-vim = super.callPackage ./neovim/ranger.nix {};
  };
}
