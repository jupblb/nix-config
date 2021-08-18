self: super: with super; {
  ammonite         = ammonite // {
    predef = pkgs.fetchurl {
      url    = https://git.io/vHaKQ;
      sha256 = "1kir3j5z3drkihx1hysdcmjaiacz840qpwbz70v4k62jr95mz3jp";
    };
  };
  chromium-wayland = callPackage ./chromium-wayland.nix {};
  fish-plugins     = import ./fish/plugins { inherit (super) callPackage; };
  htop             = callPackage ./htop { htop = super.htop; };
  lf               = callPackage ./lf { lf = super.lf; };
  luaformatter     = luaformatter.override { stdenv = gccStdenv; };
  pragmata-pro     = callPackage ./pragmata-pro {};
  python3Packages  = python3Packages // {
    mdformat = super.python3Packages.mdformat.overrideAttrs(old: {
      propagatedBuildInputs =
        let
          mdformat-gfm     = callPackage ./mdformat/mdformat-gfm.nix {
            mdformat-tables = mdformat-tables';
            python3Packages = super.python3Packages;
          };
          mdformat-tables' = callPackage ./mdformat/mdformat-tables.nix {
            python3Packages = super.python3Packages;
          };
        in old.propagatedBuildInputs ++ [ mdformat-gfm ];
    });
  };
  ripgrep          =
    let rg_12 = builtins.fetchurl
      https://raw.githubusercontent.com/NixOS/nixpkgs/85f96822a05180cbfd5195e7034615b427f78f01/pkgs/tools/text/ripgrep/default.nix;
    in callPackage rg_12 { inherit (darwin.apple_sdk.frameworks) Security; };
  vimPlugins       = vimPlugins // {
    luatab-nvim   = callPackage ./neovim/luatab.nix {};
    nabla-nvim    = callPackage ./neovim/nabla.nix {};
    telescope-coc = callPackage ./neovim/telescope-coc.nix {};
    venn-nvim     = callPackage ./neovim/venn.nix {};
  };
  zk               = callPackage ./zk.nix {};
}
