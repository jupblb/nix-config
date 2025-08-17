self: super: with super; {
  fortune     = fortune.override({ withOffensive = true; });
  gtasks-md   = callPackage ./gtasks-md.nix {
    inherit (haskellPackages) pandoc-types;
  };
  python312   = super.python312.override {
    packageOverrides = pythonSelf: pythonSuper: {
      # https://github.com/NixOS/nixpkgs/issues/336593
      iterfzf = pythonSuper.iterfzf.overridePythonAttrs(_: {
        doCheck = false;
      });
    };
  };
  vimPlugins  = super.vimPlugins // {
    no-neck-pain-nvim = super.vimUtils.buildVimPlugin(rec {
      pname   = "no-neck-pain.nvim";
      src     = super.fetchFromGitHub({
        owner  = "shortcuts";
        repo   = pname;
        rev    = "7bf83d3cfc8f6a120734f4254bbb87928756bea0";
        sha256 = "14bp8ksw3v3dw28nakxkhmzxvbwrn7kwnzpwx2zxxf1vn45az0cm";
      });
      version = "2025-07-20";
    });
    zoekt-nvim        = super.vimUtils.buildVimPlugin(rec {
      pname   = "zoekt.nvim";
      src     = super.fetchFromGitHub({
        owner  = "jupblb";
        repo   = pname;
        rev    = "27c029ba1487c26e55d42741eefad1bce5fdfbf0";
        sha256 = "sha256-vzOgq789djlTg0NGnywkJAlwCnHkpz1UA9uTiYmRqHw=";
      });
      version = "2025-08-17";
    });
  };
  vtclean     = callPackage ./vtclean.nix {};
}
