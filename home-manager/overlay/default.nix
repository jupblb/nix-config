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
        rev    = "621f1ca375fc2887d30a4ac32a8b6c582d28f9c0";
        sha256 = "sha256-/ynaY2MGLKfoljy18jnfU+KDxm3tJOTgZqxMOEerwyU=";
      });
      version = "2025-11-30";
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
