{ config, lib, pkgs, ... }: {
  home.sessionVariables = {
    Z_OWNER = config.home.username;
  };

  programs = {
    eza = {
      enable                = true;
      enableFishIntegration = false;
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
        ls                = builtins.readFile ./eza.fish;
        nix-shell         =
          "${pkgs.nix}/bin/nix-shell --run \"env SHLVL=\\$((\\$SHLVL-1)) fish\" $argv";
      };
      interactiveShellInit = builtins.readFile ./init.fish;
      plugins              = [ {
        name = "fish-async-prompt";
        src  = pkgs.callPackage ./plugin/fish-async-prompt.nix {};
      } {
        name = "z";
        src  = pkgs.callPackage ./plugin/z.nix {};
      } ] ++ [ (lib.mkIf (!builtins.pathExists "/etc/nixos") {
        name = "nix-env";
        src  = pkgs.callPackage ./plugin/nix-env.nix {};
      }) ];
      shellAliases         = {
        cat  = "${pkgs.bat}/bin/bat --style=plain --paging=never";
        diff = "${pkgs.difftastic}/bin/difft --background=light --tab-width=2";
        less = "${pkgs.bat}/bin/bat --style=plain --paging=always";
      };
    };

    git.extraConfig.bash = {
      showDirtyState        = true;
      showInformativeStatus = true;
      showUntrackedFiles    = true;
    };

    kitty.settings = {
      env   = "SHELL=${pkgs.fish}/bin/fish";
      shell = "${pkgs.fish}/bin/fish";
    };

    neovim.extraConfig =
      "set shell=${lib.meta.getExe config.programs.fish.package}";
  };
}
