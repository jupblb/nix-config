self: super: with super; {
  ammonite         = ammonite // {
    predef = pkgs.fetchurl {
      url    = https://git.io/vHaKQ;
      sha256 = "1kir3j5z3drkihx1hysdcmjaiacz840qpwbz70v4k62jr95mz3jp";
    };
  };
  chromium-wayland = callPackage ./chromium-wayland/default.nix {};
  fishPlugins      = import ./fish { inherit (super) callPackage; };
  delta            = callPackage ./delta { delta = super.delta; };
  k8s-test-infra   = callPackage ./kubernetes/test-infra.nix {};
  lf               = callPackage ./lf { lf = super.lf; };
  lf-previewer     = callPackage ./lf/previewer.nix {};
  htop             = callPackage ./htop { htop = super.htop; };
  neovim-nightly   = callPackage ./neovim {};
  pragmata-pro     = callPackage ./pragmata-pro {};
  vimPlugins       = vimPlugins // {
    compe-tabnine = vimPlugins.compe-tabnine.overrideAttrs(old: {
      postFixup = old.postFixup + ''
        ln -s ${tabnine}/bin/TabNine-deep-* $target/binaries/
      '';
    });
    lf-vim        = callPackage ./neovim/lf-vim.nix {
      inherit (vimPlugins) lf-vim vim-bbye;
    };
  };
}
