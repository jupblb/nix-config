{ config, lib, pkgs, ... }: {
  home = {
    packages         = with pkgs; [ fswatch ];
    sessionVariables = { PAGER = "${pkgs.less}/bin/less -R"; };
    shellAliases     = {
      root = "cd $(${pkgs.git}/bin/git rev-parse --show-toplevel)";
    };
  };

  imports = [ ./amp.nix ];

  nix = {
    package  = lib.mkDefault pkgs.nix;
    settings = { experimental-features = [ "nix-command" "flakes" ]; };
  };

  nixpkgs.overlays = [ (import ./overlay) ];

  programs = {
    bat = {
      config = { theme = "gruvbox-light"; };
      enable = true;
    };

    bash = {
      enable         = true;
      historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
      historyFile    = "${config.xdg.cacheHome}/bash/history";
      shellAliases   = { "ls" = "ls --color=auto"; };
      shellOptions   = [ "cdspell" "checkwinsize" "cmdhist" "histappend" ];
    };

    delta = {
      enable               = true;
      enableGitIntegration = true;
      options              = {
        line-numbers     = true;
        minus-emph-style = "syntax #fa9f86";
        minus-style      = "syntax #f9d8bc";
        plus-emph-style  = "syntax #d9d87f";
        plus-style       = "syntax #eeebba";
        syntax-theme     = "gruvbox-light";
        tabs             = 2;
      };
    };

    direnv = {
      config     = {
        bash_path     = "${pkgs.bashInteractive}/bin/bash";
        disable_stdin = true;
        strict_env    = true;
      };
      enable     = true;
      nix-direnv = { enable = true; };
    };

    git = {
      enable   = true;
      ignores  = [
        ".actrc" ".bazelrc.local" ".direnv" ".envrc" ".nvim.lua" ".zoekt"
        "PROMPT*.md"
      ];
      # https://blog.gitbutler.com/how-git-core-devs-configure-git/
      # https://github.blog/engineering/improve-git-monorepo-performance-with-a-file-system-monitor/
      settings = {
        alias               = {
          amend     = "commit --amend --no-edit --allow-empty-message";
          fuck      = "reset --hard HEAD";
          increment = "commit --allow-empty-message -m ''";
        };
        branch.sort         = "-committerdate";
        color.ui            = true;
        column.ui           = "auto";
        commit.verbose      = true;
        core                = {
          fsmonitor      = true;
          mergeoptions   = "--no-edit";
          untrackedCache = true;
        };
        credential.helper   = [ "cache --timeout 43200" ]; # 12 hours
        diff                = {
          algorithm = "histogram";
          colorMoved = "plain";
        };
        rebase              = {
          autoSquash = true;
          autoStash  = true;
          updateRefs = true;
        };
        rerere              = { enabled = true; autoUpdate = true; };
        fetch               = { all = true; prune = true; };
        help.autocorrect    = true;
        init.defaultBranch  = "main";
        merge.conflictStyle = "zdiff3";
        pull.rebase         = true;
        push                = { autoSetupRemote = true; default = "current"; };
        submodule.recurse   = true;
        user                = { email = "git@kielbowi.cz"; name = "jupblb"; };
      };
      signing  = {
        format        = "ssh";
        key           = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        signByDefault = true;
      };
    };

    git-credential-oauth = { enable = true; };

    htop = {
      enable   = true;
      settings = { hide_threads = true; hide_userland_threads = true; };
    };

    ssh = {
      enable              = true;
      enableDefaultConfig = false;
      matchBlocks         = {
        "*"          = {
          controlMaster  = "auto";
          controlPersist = "yes";
        };
        hades        = {
          hostname     = "hades.kielbowi.cz";
          proxyCommand =
            "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
          user         = "jupblb";
        };
        dionysus     = {
          hostname     = "dionysus.kielbowi.cz";
          proxyCommand =
            "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
          user         = "jupblb";
        };
      };
    };
  };

  xdg = { enable = true; };
}
