{ pkgs, ... }: {
  programs = {
    exa.enable = true;

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
        ls                = builtins.readFile ./exa.fish;
        nix-shell         =
          "${pkgs.nix}/bin/nix-shell --run \"env SHLVL=\\$((\\$SHLVL-1)) fish\" $argv";
      };
      interactiveShellInit = ''
        delta-view
        printf '\033[5 q\r'
        set -U async_prompt_functions fish_right_prompt
      '';
      plugins              = [ {
        name = "fish-async-prompt";
        src  = pkgs.callPackage ./fish-async-prompt.nix {};
      } ];
      shellAliases         = {
        cat  = "${pkgs.bat}/bin/bat -p --paging=never";
        diff = "${pkgs.difftastic}/bin/difft --background=light --tab-width=2";
        less = "${pkgs.bat}/bin/bat -p --paging=always";
      };
    };

    git.extraConfig.bash = {
      showDirtyState        = true;
      showInformativeStatus = true;
      showUntrackedFiles    = true;
    };
  };
}
