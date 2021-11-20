self: super: with super; {
  ammonite                = ammonite // {
    predef = pkgs.fetchurl {
      url    = https://git.io/vHaKQ;
      sha256 = "1kir3j5z3drkihx1hysdcmjaiacz840qpwbz70v4k62jr95mz3jp";
    };
  };
  emanote                 =
    let url = "https://github.com/srid/emanote/archive/master.tar.gz";
    in (import (builtins.fetchTarball url)).default;
  fishPlugins             = fishPlugins // {
    gcloud  = callPackage ./fish/gcloud.nix {};
    gruvbox = callPackage ./fish/gruvbox.nix {};
    kubectl = callPackage ./fish/kubectl.nix {};
    nix-env = callPackage ./fish/nix-env.nix {};
  };
  jsonnet-language-server = callPackage ./jsonnet-language-server.nix {};
  lf                      = callPackage ./lf { lf = super.lf; };
  pragmata-pro            = callPackage ./pragmata-pro {};
  vimPlugins              = vimPlugins // {
    luatab-nvim               = callPackage ./neovim/luatab.nix {};
    neoclip                   = callPackage ./neovim/neoclip.nix {};
    null-ls-nvim              = vimPlugins.null-ls-nvim.overrideAttrs(_: {
      dependencies = [];
    });
    nvim-metals               = callPackage ./neovim/nvim-metals.nix {
      inherit (vimPlugins) plenary-nvim;
    };
    schemastore               = callPackage ./neovim/schemastore.nix {};
    telescope-fzf-native-nvim = vimPlugins.telescope-fzf-native-nvim.overrideAttrs(_: {
      dependencies = [];
    });
    telescope-lsp-handlers    = callPackage ./neovim/telescope-lsp-handlers.nix {};
    telescope-vim-bookmarks   = callPackage ./neovim/telescope-vim-bookmarks.nix {};
    venn-nvim                 = callPackage ./neovim/venn.nix {};
  };
  zk                      = callPackage ./zk.nix {};
}
