{ pkgs, ... }: {
  programs = {
    exa.enable = true;

    fish = {
      enable               = true;
      functions            = {
        delta-view    = {
          body     = builtins.readFile ./delta-view.fish;
          onSignal = "WINCH";
        };
        fish_greeting =
          "if test $SHLVL -eq 1; ${pkgs.fortune}/bin/fortune -sa; end";
        ls            = builtins.readFile ./exa.fish;
      };
      interactiveShellInit = "delta-view";
      shellAliases         = {
        cat  = "${pkgs.bat}/bin/bat -p --paging=never";
        diff = "${pkgs.difftastic}/bin/difft --background=light";
        less = "${pkgs.bat}/bin/bat -p --paging=always";
      };
    };
  };
}
