{ config, lib, pkgs, ... }: {
  home = { sessionVariables = { Z_OWNER = config.home.username; }; };

  programs = {
    eza = {
      enable       = true;
      extraOptions = [ "--group-directories-first" ];
      icons        = "never";
    };

    fish = {
      enable               = true;
      functions            = {
        bak               = "cp -r $argv[1] $argv[1].bak";
        delta-view        = {
          body     = builtins.readFile ./delta-view.fish;
          onSignal = "WINCH";
        };
        fish_greeting     =
          "if test $SHLVL -eq 1; ${pkgs.fortune}/bin/fortune -sa; end";
        fish_prompt       = builtins.readFile ./prompt.fish;
        fish_mode_prompt  = "";
        fish_right_prompt = builtins.readFile ./rprompt.fish;
      };
      interactiveShellInit = builtins.readFile ./init.fish;
      plugins              = with pkgs.fishPlugins; [
        { name = async-prompt.pname; src = async-prompt.src; }
        { name = z.pname;            src  = z.src;           }
      ];
      shellAliases         = {
        bash = "${pkgs.bashInteractive}/bin/bash";
        cat  = "${pkgs.bat}/bin/bat --style=plain --paging=never";
        diff = "${pkgs.difftastic}/bin/difft --background=light --tab-width=2";
        less = "${pkgs.bat}/bin/bat --style=plain --paging=always";
        ls   = "eza";
      };
    };

    git = {
      settings = {
        bash = {
          showDirtyState        = true;
          showInformativeStatus = true;
          showUntrackedFiles    = true;
        };
      };
    };

    kitty.settings = {
      env   = "SHELL=${pkgs.fish}/bin/fish";
      shell = "${pkgs.fish}/bin/fish";
    };

    neovim.extraConfig =
      "set shell=${lib.meta.getExe config.programs.fish.package}";

    nix-your-shell = { enable = true; };
  };
}
