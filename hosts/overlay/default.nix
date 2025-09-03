final: prev: {
  fortune     = prev.fortune.override({ withOffensive = true; });
  gtasks-md   = final.callPackage ./gtasks-md.nix {
    inherit (final.haskellPackages) pandoc-types;
  };
  python312   = prev.python312.override {
    packageOverrides = pythonSelf: pythonSuper: {
      # https://github.com/NixOS/nixpkgs/issues/336593
      iterfzf = pythonSuper.iterfzf.overridePythonAttrs(_: {
        doCheck = false;
      });
    };
  };
  vimPlugins  = prev.vimPlugins // {
    no-neck-pain-nvim = final.vimUtils.buildVimPlugin(rec {
      pname   = "no-neck-pain.nvim";
      src     = final.fetchFromGitHub({
        owner  = "shortcuts";
        repo   = pname;
        rev    = "7bf83d3cfc8f6a120734f4254bbb87928756bea0";
        sha256 = "14bp8ksw3v3dw28nakxkhmzxvbwrn7kwnzpwx2zxxf1vn45az0cm";
      });
      version = "2025-07-20";
    });
    zoekt-nvim        = final.vimUtils.buildVimPlugin(rec {
      pname   = "zoekt.nvim";
      src     = final.fetchFromGitHub({
        owner  = "jupblb";
        repo   = pname;
        rev    = "0894e02618b1890362face316f52e93bfb3c4c98";
        sha256 = "sha256-F9WS4mjUIA1T8Gjj4BaGi8NZREaAJlQQHoENYT9VA40=";
      });
      version = "2025-08-17";
    });
  };
}
