self: super: with super; {
  fortune    = fortune.override({ withOffensive = true; });
  git-tidy   = callPackage ./git-tidy.nix {
    inherit (rustPlatform) buildRustPackage;
  };
  gtasks-md  = callPackage ./gtasks-md.nix {
    inherit (haskellPackages) pandoc-types;
  };
  mkalias    = callPackage ./mkalias.nix {
    inherit (darwin) apple_sdk;
    inherit (rustPlatform) buildRustPackage;
  };
  vimPlugins = super.vimPlugins // {
    codecompanion-nvim = super.vimUtils.buildVimPlugin({
      pname   = "codecompanion.nvim";
      version = "2025-02-07";
      src     = super.fetchFromGitHub {
        owner  = "olimorris";
        repo   = "codecompanion.nvim";
        rev    = "29c8c9142169c447ad1374bbb6885c611506fda3";
        sha256 = "sha256-Al72q0c+uch62e6TW+IS3A6i2x4gCqT0P0bAEJ9Him0=";
      };
    });
  };
  vtclean    = callPackage ./vtclean.nix {};
}
