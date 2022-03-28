self: super: with super; {
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
    hop-nvim                    = vimPlugins.hop-nvim.overrideAttrs(_: {
      patches =
        let patch = builtins.fetchurl
          "https://github.com/phaazon/hop.nvim/commit/fa205b6d58f8cb014f66d410f30d05316452742c.patch";
        in [ patch ];
    });
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
    zk-nvim                     = callPackage ./neovim/plugin/zk.nix {};
  };
}
