self: super: with super; {
  fortune   = fortune.override({ withOffensive = true; });
  gtasks-md = callPackage ./gtasks-md.nix {
    inherit (haskellPackages) pandoc-types;
  };
  python312 = super.python312.override {
    packageOverrides = pythonSelf: pythonSuper: {
      # https://github.com/NixOS/nixpkgs/issues/336593
      iterfzf = pythonSuper.iterfzf.overridePythonAttrs(_: {
        doCheck = false;
      });
    };
  };
  vtclean   = callPackage ./vtclean.nix {};
}
