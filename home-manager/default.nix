{ lib, pkgs, ... }: {
  home = {
    activation = {
      bat = lib.hm.dag.entryAfter ["writeBoundary"]
        "$DRY_RUN_CMD ${pkgs.bat}/bin/bat cache --build";
    };
    packages   = with pkgs; [ git-crypt ripgrep ];
    username   = "jupblb";
  };

  nixpkgs.overlays = [ (import ../overlay) ];

  programs = {
    bat  = {
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
        "--preview '${pkgs.gtree}/bin/gtree -L=2 {} | head -200'"
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
        color.ui            = true;
        core.mergeoptions   = "--no-edit";
        fetch.prune         = true;
        merge.conflictStyle = "diff3";
        pull.rebase         = true;
        push.default        = "upstream";
        submodule.recurse   = true;
      };
      iniContent  = {
        core.pager =
          lib.mkForce "sh -c 'delta --width \${FZF_PREVIEW_COLUMNS-$COLUMNS}'";
      };
      signing     = { key = "1F516D495D5D8D5B"; signByDefault = true; };
      userEmail   = "mpkielbowicz@gmail.com";
      userName    = "jupblb";
    };

    htop = {
      enable   = true;
      settings = { hide_threads = true; hide_userland_threads = true; };
    };

    ssh = {
      compression         = true;
      controlMaster       = "auto";
      controlPersist      = "yes";
      enable              = true;
      forwardAgent        = true;
      matchBlocks         = let config = { identitiesOnly = true; }; in {
        cerberus     = config // {
          hostname     = "192.168.1.1";
          identityFile = [ (toString ../config/ssh/jupblb/id_ed25519) ];
          user         = "root";
        };
        dionysus     = config // {
          hostname     = "dionysus.kielbowi.cz";
          identityFile = [ (toString ../config/ssh/jupblb/id_ed25519) ];
          port         = 1995;
        };
        "github.com" = config // {
          hostname     = "github.com";
          identityFile = [ (toString ../config/ssh/git/id_ed25519) ];
        };
        poseidon     = config // {
          hostname     = "poseidon.kielbowi.cz";
          identityFile = [ (toString ../config/ssh/jupblb/id_ed25519) ];
        };
      };
      serverAliveInterval = 30;
    };
  };

  xdg.enable = true;
}
