self: super: with super; {
  fortune    = fortune.override({ withOffensive = true; });
  gtasks-md  = callPackage ./gtasks-md.nix {
    inherit (haskellPackages) pandoc-types;
  };
  # https://github.com/NixOS/nixpkgs/issues/371837
  jackett    = super.jackett.overrideAttrs { doCheck = false; };
  mkalias    = callPackage ./mkalias.nix {
    inherit (darwin) apple_sdk;
    inherit (rustPlatform) buildRustPackage;
  };
  vimPlugins = super.vimPlugins // {
    codecompanion-nvim = super.vimUtils.buildVimPlugin({
      pname   = "codecompanion.nvim";
      version = "2025-04-12";
      src     = super.fetchFromGitHub {
        owner  = "olimorris";
        repo   = "codecompanion.nvim";
        rev    = "35b11dc4b292519a5c09fb2c0c0e8a8832e9e821";
        sha256 = "sha256-c/xK+hjZVxGQYu6lImUt3U0WJ2bcMz4uGMv+BBZP1Mk=";
      };
    });
  };
  vtclean    = callPackage ./vtclean.nix {};
}
