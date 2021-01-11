self: super: {
  emacs-wrapped  = super.callPackage ./emacs {};
  fishPlugins    = import ./fish { inherit (super) callPackage; };
  neovim-nightly = super.callPackage ./neovim {};
  pragmata-pro   = super.callPackage ./pragmata-pro {};
  ranger         = super.callPackage ./ranger {};
  vimPlugins     = super.vimPlugins // {
    ranger-vim = super.callPackage ./neovim/ranger.nix {};
  };
}
