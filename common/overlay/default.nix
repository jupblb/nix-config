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
      src = fetchFromGitHub {
        owner  = "phaazon";
        repo   = "hop.nvim";
        rev    = "e2f978b50c2bd9ae2c6a4ebdf2222c0f299c85c3";
        sha256 = "1si2ibxidjn0l565vhr77949s16yjv46alq145b19h15amwgq3g2";
      };
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
