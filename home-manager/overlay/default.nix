final: prev: {
  fortune     = prev.fortune.override({ withOffensive = true; });
  gtasks-md   = final.callPackage ./gtasks-md.nix {
    inherit (final.haskellPackages) pandoc-types;
  };
  vimPlugins  = prev.vimPlugins // {
    amp-nvim          = final.vimUtils.buildVimPlugin(rec {
      pname   = "amp.nvim";
      src     = final.fetchFromGitHub({
        owner  = "sourcegraph";
        repo   = pname;
        rev    = "3b9ad5ef0328de1b35cc9bfa723a37db5daf9434";
        sha256 = "sha256-f/li32jpVigbZANnnbgSArnOH4nusj0DUz7952K+Znw=";
      });
      version = "2025-12-17";
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
