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
    no-neck-pain-nvim = super.vimUtils.buildVimPlugin {
      pname   = "no-neck-pain.nvim";
      src     = super.fetchFromGitHub {
        owner  = "shortcuts";
        repo   = "no-neck-pain.nvim";
        rev    = "7bf83d3cfc8f6a120734f4254bbb87928756bea0";
        sha256 = "14bp8ksw3v3dw28nakxkhmzxvbwrn7kwnzpwx2zxxf1vn45az0cm";
      };
      version = "2025-07-20";
    };
  };
  vtclean     = callPackage ./vtclean.nix {};
}
