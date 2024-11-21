{ config, pkgs, ... }: {
  home = {
    packages         = with pkgs; [ fswatch ];
    username         = "jupblb";
    sessionVariables = {
      PAGER = "${pkgs.less}/bin/less -R";

      # XDG setup:
      # - run xdg-ninja to find out messed up directories
      # - consult https://wiki.archlinux.org/title/XDG_Base_Directory#Support
      ANDROID_HOME          = "${config.xdg.cacheHome}/android";
      AZURE_CONFIG_DIR      = "${config.xdg.dataHome}/azure";
      GTK2_RC_FILES         = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      CARGO_HOME            = "${config.xdg.cacheHome}/cargo";
      GRADLE_USER_HOME      = "${config.xdg.cacheHome}/gradle";
      LESSHISTFILE          = "${config.xdg.cacheHome}/less/history";
      NODE_REPL_HISTORY     = "${config.xdg.dataHome}/node/history";
      NPM_CONFIG_USERCONFIG =
        let npmrc = pkgs.writeText "npmrc" ''
          cache=${config.xdg.cacheHome}/npm
          init-module=${config.xdg.configHome}/npm/npm-init.js
          prefix=${config.xdg.dataHome}/npm
          userconfig=${config.xdg.configHome}/npm/npmrc
        '';
        in "${npmrc}";
      PSQL_HISTORY          = "${config.xdg.cacheHome}/psql/history";
      PYTHON_HISTORY        = "${config.xdg.dataHome}/python/history";
      SQLITE_HISTORY        = "${config.xdg.cacheHome}/sqlite/history";
    };
  };

  nixpkgs.overlays = [ (import ../overlay) ];

  programs = {
    bat = {
      config = { theme = "gruvbox-light"; };
      enable = true;
    };

    bash = {
      enable           = true;
      historyControl   = [ "erasedups" "ignoredups" "ignorespace" ];
      historyFile      = "${config.xdg.cacheHome}/bash/history";
      sessionVariables = {
        PS1 = "\[\e[0;32m\]\u@\h \[\e[0;37m\]\w\[\e[0;34m\] $ \[\e[0m\]";
      };
      shellAliases     = { "ls" = "ls --color=auto"; };
      shellOptions     = [ "cdspell" "checkwinsize" "cmdhist" "histappend" ];
      initExtra        = "source ${toString ../config/bashrc.bash}";
    };

    git = {
      aliases     = {
        amend     = "commit --amend --no-edit --allow-empty-message";
        fuck      = "reset --hard HEAD";
        increment = "commit --allow-empty-message -m ''";
      };
      delta       = {
        enable  = true;
        options = {
          line-numbers     = true;
          minus-emph-style = "syntax #fa9f86";
          minus-style      = "syntax #f9d8bc";
          plus-emph-style  = "syntax #d9d87f";
          plus-style       = "syntax #eeebba";
          syntax-theme     = "gruvbox-light";
        };
      };
      enable      = true;
      extraConfig = {
        color.ui            = true;
        commit.verbose      = true;
        core.mergeoptions   = "--no-edit";
        diff.algorithm      = "histogram";
        fetch.prune         = true;
        init.defaultBranch  = "main";
        merge.conflictStyle = "zdiff3";
        pull.rebase         = true;
        push.default        = "current";
        submodule.recurse   = true;
      };
      package     = pkgs.buildEnv {
        name  = "git-custom";
        paths = with pkgs; [ git git-tidy ];
      };
      userEmail   = "git@kielbowi.cz";
      userName    = "jupblb";
    };

    git-credential-oauth.enable = true;

    htop = {
      enable   = true;
      settings = { hide_threads = true; hide_userland_threads = true; };
    };
  };

  xdg.enable = true;
}
