self: super: with super; {
  ammonite                = ammonite // {
    predef = pkgs.fetchurl {
      url    = "https://git.io/vHaKQ";
      sha256 = "1kir3j5z3drkihx1hysdcmjaiacz840qpwbz70v4k62jr95mz3jp";
    };
  };
  emanote                 =
    let url = "https://github.com/srid/emanote/archive/master.tar.gz";
    in (import (builtins.fetchTarball url)).default;
  fishPlugins             = fishPlugins // {
    gcloud  = callPackage ./fish/plugin/gcloud.nix {};
    kubectl = callPackage ./fish/plugin/kubectl.nix {};
    nix-env = callPackage ./fish/plugin/nix-env.nix {};
  };
  gtree                   = callPackage ./gtree.nix {};
  lf                      = callPackage ./lf { inherit (super) lf; };
  pragmata-pro            = callPackage ./pragmata-pro {};
  vimPlugins              = vimPlugins // {
    cmp-nvim-lsp-signature-help =
      callPackage ./neovim/plugin/cmp-nvim-lsp-signature-help.nix {};
    gkeep-nvim                  = callPackage ./neovim/plugin/gkeep.nix {};
    null-ls-nvim                = vimPlugins.null-ls-nvim.overrideAttrs(_: {
      dependencies = with vimPlugins; [ plenary-nvim ];
    });
    nvim-pqf                    = callPackage ./neovim/plugin/pqf.nix {};
    telescope-fzf-native-nvim   =
      vimPlugins.telescope-fzf-native-nvim.overrideAttrs(_: {
        dependencies = [];
      });
    telescope-tele-tabby-nvim   =
      callPackage ./neovim/plugin/telescope-tele-tabby.nix {};
  };
}
