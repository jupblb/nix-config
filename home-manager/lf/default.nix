{ config, pkgs, ... }: {
  home = {
    packages         = with pkgs; [ fd ];
    sessionVariables = { ZO_METHOD = "lf"; };
  };

  programs = {
    fish.functions = { lf = builtins.readFile ./lf-vim.fish; };

    lf = {
      enable    = true;
      previewer = {
        keybinding = "`";
        source     = "${config.programs.pistol.package}/bin/pistol";
      };
      settings  = { hidden = true; icons = true; tabstop = 4; };
    };

    pistol = {
      associations = [ {
        command = "${pkgs.glow}/bin/glow -s light -- %pistol-filename%";
        fpath   = ".*.md$";
      } {
        command = "${pkgs.jq}/bin/jq --color-output . %pistol-filename%";
        mime    = "application/json";
      } {
        command =
          "${pkgs.bat}/bin/bat --style=numbers --color=always %pistol-filename%";
        mime    = "text/*";
      } {
        command =
          "${pkgs.bat}/bin/bat --style=numbers --color=always %pistol-filename%";
        mime    = "application/javascript";
      } ];
      enable       = true;
    };
  };

  xdg.configFile = {
    "lf/icons".source = pkgs.fetchurl {
      sha256 = "sha256-c0orDQO4hedh+xaNrovC0geh5iq2K+e+PZIL5abxnIk=";
      url    = "https://github.com/gokcehan/lf/raw/master/etc/icons.example";
    };
  };
}
