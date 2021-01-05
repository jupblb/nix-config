self: super: {
  emacs-wrapped  = super.callPackage ./emacs {};
  fishPlugins    = import ./fish { inherit (super) callPackage; };
  neovim-nightly = super.callPackage ./neovim {};
  pragmata-pro   = super.callPackage ./pragmata-pro {};
}
