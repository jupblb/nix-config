self: super: rec {
  chromium-wayland = super.callPackage ./chromium-wayland/default.nix {};
  fishPlugins      = import ./fish { inherit (super) callPackage; };
  k8s-test-infra   = super.callPackage ./kubernetes/test-infra.nix {};
  lf               = super.callPackage ./lf { lf = super.lf; };
  lf-previewer     = super.callPackage ./lf/previewer.nix {};
  htop             = super.callPackage ./htop { htop = super.htop; };
  neovim-nightly   = super.callPackage ./neovim {};
  pragmata-pro     = super.callPackage ./pragmata-pro {};
  vimPlugins       = super.vimPlugins // {
    lf-vim = super.callPackage ./neovim/lf-vim.nix {
      inherit (super.vimPlugins) lf-vim vim-bbye;
    };
  };
}
