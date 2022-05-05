{ config, pkgs, ... }: {
  home = {
    packages         = with pkgs; [ gore ];
    sessionVariables = { GOROOT = "${pkgs.go}/share/go"; };
  };

  programs.go = {
    enable = true;
    goPath = "${config.xdg.cacheHome}/go";
  };
}
