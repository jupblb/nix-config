self: super: {
  fishPlugins    = {
    gruvbox    = super.callPackage ./fish/gruvbox.nix {};
    nix-env    = super.callPackage ./fish/nix-env.nix {};
    bobthefish = super.callPackage ./fish/bobthefish.nix {};
  };
  gitAndTools    = super.gitAndTools // {
    delta = super.callPackage ./delta {
      inherit (super.darwin.apple_sdk.frameworks) Security;
    };
  };
  neovim-nightly = super.callPackage ./neovim {};
  vimPlugins     = super.vimPlugins // {
    glow               = super.callPackage ./neovim/glow.nix {};
    treesitter-context = super.callPackage ./neovim/treesitter-context.nix {};
  };
}
