{ config, pkgs, ... }: {
  home.packages = with pkgs; [ git-crypt ];

  programs = {
    gpg = {
      enable  = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };
  };
}
