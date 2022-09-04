{ pkgs, ... }: {
  programs = {
    exa.enable = true;

    fish = {
      enable               = true;
      functions            = {
        bak           = "cp -r $argv[1] $argv[1].bak";
        delta-view    = {
          body     = builtins.readFile ./delta-view.fish;
          onSignal = "WINCH";
        };
        fish_greeting =
          "if test $SHLVL -eq 1; ${pkgs.fortune}/bin/fortune -sa; end";
        ls            = builtins.readFile ./exa.fish;
        nix-shell     =
          "${pkgs.nix}/bin/nix-shell --run \"env SHLVL=\\$((\\$SHLVL-1)) fish\" $argv";
      };
      interactiveShellInit = ''
        delta-view
        printf '\033[5 q\r'
        ${builtins.readFile ./tide.fish}
      '';
      plugins              = [ {
        name = "tide";
        src  = pkgs.callPackage ./tide.nix {};
      } ];
      shellAliases         = {
        cat  = "${pkgs.bat}/bin/bat -p --paging=never";
        diff = "${pkgs.difftastic}/bin/difft --background=light --tab-width=2";
        less = "${pkgs.bat}/bin/bat -p --paging=always";
      };
    };
  };
}
