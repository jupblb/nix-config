self: super: with super; {
  fortune   = fortune.override({ withOffensive = true; });
  gtasks-md = callPackage ./gtasks-md.nix {
    inherit (haskellPackages) pandoc-types;
  };
  mkalias   = callPackage ./mkalias.nix {
    inherit (darwin) apple_sdk;
    inherit (rustPlatform) buildRustPackage;
  };
  vtclean   = callPackage ./vtclean.nix {};
}
