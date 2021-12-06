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
    gcloud  = callPackage ./fish/plugin/gcloud.nix {};
    gruvbox = callPackage ./fish/plugin/gruvbox.nix {};
    kubectl = callPackage ./fish/plugin/kubectl.nix {};
    nix-env = callPackage ./fish/plugin/nix-env.nix {};
  };
  lf                      = callPackage ./lf { lf = super.lf; };
  pragmata-pro            = callPackage ./pragmata-pro {};
  vimPlugins              = vimPlugins // {
    null-ls-nvim              = vimPlugins.null-ls-nvim.overrideAttrs(_: {
      dependencies = with vimPlugins; [ plenary-nvim ];
    });
    nvim-pqf                  = callPackage ./neovim/plugin/pqf.nix {};
    telescope-fzf-native-nvim =
      vimPlugins.telescope-fzf-native-nvim.overrideAttrs(_: {
        dependencies = [];
      });
  };
  zk                      = callPackage ./zk.nix {};
}
