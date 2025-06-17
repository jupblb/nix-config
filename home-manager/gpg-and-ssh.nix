{ config, pkgs, ... }: {
  home.packages = with pkgs; [ git-crypt ];

  programs = {
    git = { signing = { key = "1F516D495D5D8D5B"; signByDefault = true; }; };
    gpg = {
      enable  = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };
  };
}
