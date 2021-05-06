self: super: with super; {
  chromium-wayland = callPackage ./chromium-wayland/default.nix {};
  fishPlugins      = import ./fish { inherit (super) callPackage; };
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
