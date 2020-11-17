self: super: {
  fishPlugins    = {
    nix-env          = super.callPackage ./fish/nix-env.nix {};
    theme-bobthefish = super.callPackage ./fish/theme-bobthefish.nix {};
  };
  gitAndTools    = super.gitAndTools // {
    delta = super.callPackage ./delta {
      inherit (super.darwin.apple_sdk.frameworks) Security;
    };
  };
  neovim-nightly = super.callPackage ./neovim {};
  ranger         = super.callPackage ./ranger { ranger = super.ranger; };
  vimPlugins     = super.vimPlugins // {
    glow               = super.callPackage ./neovim/glow.nix {};
    treesitter-context = super.callPackage ./neovim/treesitter-context.nix {};
  };
}
