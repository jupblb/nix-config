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
        rev    = "5d943d3e6aee297b23020a035a23785f7ec45737";
        sha256 = "sha256-l6zNoKVmC2hw+YDa4aj28zlFvaxF91QlVOGo/fwIqu0=";
      });
      version = "2025-09-22";
    });
  };
}
