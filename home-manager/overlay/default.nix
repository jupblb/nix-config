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
    amp-nvim          = final.vimUtils.buildVimPlugin(rec {
      pname   = "amp.nvim";
      src     = final.fetchFromGitHub({
        owner  = "sourcegraph";
        repo   = pname;
        rev    = "aabe39d682b033a3cd2c1b53648e79b7f53bccfb";
        sha256 = "sha256-lyRMoxlBw/7UmEYYJLtPgLZuHgf2lDw6zH60Ww6j9eQ=";
      });
      version = "2025-10-17";
    });
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
