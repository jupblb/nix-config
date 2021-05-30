self: super: with super; {
  ammonite         = ammonite // {
    predef = pkgs.fetchurl {
      url    = https://git.io/vHaKQ;
      sha256 = "1kir3j5z3drkihx1hysdcmjaiacz840qpwbz70v4k62jr95mz3jp";
    };
  };
  chromium-wayland = callPackage ./chromium-wayland/default.nix {};
  fishPlugins      = import ./fish { inherit (super) callPackage; };
  k8s-test-infra   = callPackage ./kubernetes/test-infra.nix {};
  lf               = (callPackage ./lf { lf = super.lf; }) // {
    lfcd-fish = pkgs.fetchurl {
      url    =
        https://raw.githubusercontent.com/gokcehan/lf/master/etc/lfcd.fish;
      sha256 = "16lagjvrm0wg7ddywv1l4l0b9cw8mvd7lfhyq6p454m93x15y4m3";
    };
    previewer = callPackage ./lf/previewer.nix {};
  };
  htop             = callPackage ./htop { htop = super.htop; };
  neovim-nightly   = callPackage ./neovim {};
  pragmata-pro     = callPackage ./pragmata-pro {};
  vimPlugins       = vimPlugins // {
    compe-tabnine    = callPackage ./neovim/compe-tabnine.nix {
      inherit (vimPlugins) compe-tabnine;
    };
    google-filetypes = callPackage ./neovim/google-filetypes.nix {};
    lf-vim           = callPackage ./neovim/lf-vim.nix {
      inherit (vimPlugins) lf-vim vim-bbye;
    };
  };
}
