self: super: rec {
  emacs-wrapped    = super.callPackage ./emacs {};
  chromium-wayland = super.callPackage ./chromium-wayland/default.nix {};
  fish-foreign-env = fishPlugins.foreign-env;
  fishPlugins      = import ./fish { inherit (super) callPackage; };
  neovim-nightly   = super.callPackage ./neovim {};
  pragmata-pro     = super.callPackage ./pragmata-pro {};
  ranger           = super.callPackage ./ranger { ranger = super.ranger; };
  vimPlugins       = super.vimPlugins // {
    ranger-vim = super.callPackage ./neovim/ranger.nix {};
  };
}
