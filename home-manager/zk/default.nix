{ config, pkgs, ... }: {
  home = {
    packages         = with pkgs; [ zk ];
    sessionVariables = {
      ZK_NOTEBOOK_DIR = "${config.home.homeDirectory}/Documents/notes";
    };
  };

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [ {
      config = "source ${toString ./neovim.vim}\n";
      plugin = zk-nvim;
    } ];
  };

  xdg.configFile = {
    "zk/config.toml".source          =
      let toml = pkgs.formats.toml {}; in toml.generate "config.toml" {
        alias           = {
          new-       = "zk new                --title \"$argv\"       ";
          new-google = "zk new --group=google --title \"$argv\" google";
          new-swps   = "zk new --group=swps   --title \"$argv\" swps  ";
          todo       = "zk edit google/todo.md";
        };
        extra           = {
          lang       = "en_us";
          visibility = "public";
        };
        format.markdown = { link-drop-extension = false; };
        group           = {
          google.extra = { visibility = "private"; };
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
