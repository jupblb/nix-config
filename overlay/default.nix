self: super:
let
  unstable-tarball = builtins.fetchTarball({
    url = "https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz";
  });
  nixpkgs-unstable = import unstable-tarball { config = super.config; };
in with super; {
  amp-cli     = nixpkgs-unstable.amp-cli;
  fortune     = fortune.override({ withOffensive = true; });
  gemini-cli  = nixpkgs-unstable.gemini-cli;
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
    no-neck-pain-nvim = nixpkgs-unstable.vimPlugins.no-neck-pain-nvim;
  };
  vtclean     = callPackage ./vtclean.nix {};
}
