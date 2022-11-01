{ lib, pkgs, ... }: {
  home = {
    activation       = {
      bat = lib.hm.dag.entryAfter ["writeBoundary"]
        "$DRY_RUN_CMD ${pkgs.bat}/bin/bat cache --build";
    };
    packages         = with pkgs; [ git-crypt ripgrep ];
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

    fzf = {
      enable                 = true;
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --hidden --type d";
      changeDirWidgetOptions = [
        "--preview '${pkgs.exa}/bin/exa -RT -L 2 --icons {} | head -200'"
      ];
      defaultCommand         = "${pkgs.fd}/bin/fd --hidden --type f";
      defaultOptions         = [ "--color=light" ];
      fileWidgetCommand      = "${pkgs.fd}/bin/fd --hidden --type f";
      fileWidgetOptions      = [
        "--preview '${pkgs.bat}/bin/bat --color=always -pp {}'"
      ];
      historyWidgetOptions   = [
        "--bind ctrl-e:preview-down,ctrl-y:preview-up"
        "--preview='echo -- {1..} | ${pkgs.fish}/bin/fish_indent --ansi'"
        "--preview-window='bottom:3:wrap'"
        "--reverse"
      ];
    };

    gpg.enable = true;

    git = {
      aliases     = {
        amend = "commit --amend --no-edit";
        fuck  = "reset --hard HEAD";
        line  = "!sh -c 'git log -L$2,+1:\${GIT_PREFIX:-./}$1' -";
        lines = "!sh -c 'git log -L$2,$3:\${GIT_PREFIX:-./}$1' -";
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
        diff.tool                     = "difftastic";
        difftool.prompt               = false;
        "difftool \"difftastic\"".cmd =
          "${pkgs.difftastic}/bin/difft --background=light --tab-width=2 $LOCAL $REMOTE";
        fetch.prune                   = true;
        merge.conflictStyle           = "diff3";
        pull.rebase                   = true;
        push.default                  = "upstream";
        sendemail.sendmailcmd         = "${pkgs.msmtp}/bin/msmtp";
        submodule.recurse             = true;
      };
      iniContent  = {
        core.pager =
          lib.mkForce "sh -c 'delta --width \${FZF_PREVIEW_COLUMNS-$COLUMNS}'";
      };
      signing     = { key = "1F516D495D5D8D5B"; signByDefault = true; };
      userEmail   = "git@kielbowi.cz";
      userName    = "jupblb";
    };

    htop = {
      enable   = true;
      settings = { hide_threads = true; hide_userland_threads = true; };
    };

    man = {
      enable         = true;
      generateCaches = true;
    };

    msmtp = {
      enable        = true;
      extraConfig   = ''
        ${builtins.readFile ../config/msmtp.conf}
        passwordeval echo "${(import ../config/secret.nix).migadu.git}"
      '';
    };

    ssh = {
      compression         = true;
      controlMaster       = "auto";
      controlPersist      = "yes";
      enable              = true;
      forwardAgent        = true;
      matchBlocks         =
        let identity = {
          identitiesOnly = true;
          identityFile   = [ (toString ../config/ssh/jupblb/id_ed25519) ];
        };
        in {
          cerberus     = identity // {
            hostname     = "192.168.1.1";
            user         = "root";
          };
          dionysus     = identity // {
            hostname     = "dionysus.kielbowi.cz";
            port         = 1995;
          };
          "github.com" = identity // {
            hostname     = "github.com";
            identityFile = [ (toString ../config/ssh/git/id_ed25519) ];
          };
          "prose.sh"   = identity // {
            hostname = "prose.sh";
          };
        };
      serverAliveInterval = 30;
    };

    tealdeer = {
      enable   = true;
      settings = {
        updates = { auto_update = true; };
      };
    };
  };

  xdg.enable = true;
}
