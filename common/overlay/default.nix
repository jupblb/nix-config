self: super: with super; {
  ammonite         = ammonite // {
    predef = pkgs.fetchurl {
      url    = https://git.io/vHaKQ;
      sha256 = "1kir3j5z3drkihx1hysdcmjaiacz840qpwbz70v4k62jr95mz3jp";
    };
  };
  chromium-wayland = callPackage ./chromium-wayland {};
  fish-plugins     = import ./fish { inherit (super) callPackage; };
  k8s-test-infra   = callPackage ./kubernetes/test-infra.nix {};
  lf               = callPackage ./lf { lf = super.lf; };
  htop             = callPackage ./htop { htop = super.htop; };
  neovim-nightly   = callPackage ./neovim {};
  pragmata-pro     = callPackage ./pragmata-pro {};
  vimPlugins       = vimPlugins // {
    compe-tabnine    = callPackage ./neovim/compe-tabnine.nix {
      inherit (vimPlugins) compe-tabnine;
      inherit (stdenv.hostPlatform) system;
    };
    google-filetypes = callPackage ./neovim/google-filetypes.nix {};
    lf-vim           = callPackage ./neovim/lf-vim.nix {
      inherit (vimPlugins) lf-vim vim-bbye;
    };
  };
}
