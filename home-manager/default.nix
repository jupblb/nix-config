{ lib, pkgs, ... }: {
  home = {
    packages         = with pkgs; [ fswatch ];
    username         = "jupblb";
    sessionVariables = { PAGER = "${pkgs.less}/bin/less -R"; };
  };

  nixpkgs.overlays = [ (import ../overlay) ];

  programs = {
    bat = {
      config = { theme = "gruvbox-light"; };
      enable = true;
    };

    bash = {
      enable         = true;
      historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
      shellAliases   = { "ls" = "ls --color=auto"; };
      shellOptions   = [ "cdspell" "checkwinsize" "cmdhist" "histappend" ];
      initExtra      = "source ${toString ../config/bashrc.bash}";
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
        color.ui                      = true;
        core.mergeoptions             = "--no-edit";
        credential.helper             = lib.mkBefore
          [ "cache --timeout ${toString(60 * 60 * 10)}" ];
        fetch.prune                   = true;
        init.defaultBranch            = "main";
        merge.conflictStyle           = "diff3";
        pull.rebase                   = true;
        push.default                  = "upstream";
        submodule.recurse             = true;
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

    ripgrep = {
      arguments = [ "--glob=!.git/*" "--hidden" "--no-ignore" ];
      enable    = true;
    };
  };

  xdg.enable = true;
}
