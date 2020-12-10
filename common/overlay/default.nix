self: super: {
  fishPlugins    = import ./fish { inherit (super) callPackage; };
  gitAndTools    = super.gitAndTools // {
    delta = super.callPackage ./delta {
      inherit (super.darwin.apple_sdk.frameworks) Security;
    };
  };
  neovim-nightly = super.callPackage ./neovim {};
  pragmata-pro   = super.callPackage ./pragmata-pro {};
}
