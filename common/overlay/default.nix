self: super: {
  emacs-wrapped    = super.callPackage ./emacs {};
  fish-foreign-env = super.fishPlugins.foreign-env;
  fishPlugins      = import ./fish { inherit (super) callPackage; };
  htop             = super.callPackage ./htop { htop = super.htop; };
  neovim-nightly   = super.callPackage ./neovim {};
  pragmata-pro     = super.callPackage ./pragmata-pro {};
  ranger           = super.callPackage ./ranger { ranger = super.ranger; };
  vimPlugins       = super.vimPlugins // {
    ranger-vim = super.callPackage ./neovim/ranger.nix {};
  };
}
