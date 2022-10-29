{ config, pkgs, ... }: {
  home = {
    packages         = with pkgs; [ zk ];
    sessionVariables = {
      ZK_NOTEBOOK_DIR = "${config.home.homeDirectory}/Documents/notes";
    };
  };

  programs = {
    fish.shellAbbrs = {
      ze = "zk edit --interactive";
      znb = "zk new --group=blog blog --title";
      zng = "zk new --group=google google --title";
      znn = "zk new --title";
      zns = "zk new --group=swps swps --title";
    };

    neovim.plugins = with pkgs.vimPlugins; [ {
      config = "source ${toString ./neovim.vim}\n";
      plugin = zk-nvim;
    } ];
  };

  xdg.configFile = {
    "zk/config.toml".source          =
      let toml = pkgs.formats.toml {}; in toml.generate "config.toml" {
        extra           = { draft = "false"; lang = "en_us"; };
        format.markdown = { link-drop-extension = false; };
        group           = {
          blog.extra   = { draft = "true"; };
          google.extra = {};
          swps.extra   = { lang = "pl"; };
        };
        note            = {
          filename = "{{slug title}}";
          ignore   = [ "assets" ];
          language = "en";
          template = toString ./template.mustache;
        };
        tool            = {
          editor      = "${config.programs.neovim.finalPackage}/bin/nvim";
          fzf-preview = "${pkgs.glow}/bin/glow --style light {-1}";
        };
      };
    "zk/templates/default.md".source = toString ./template.mustache;
  };
}
