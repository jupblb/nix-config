{ config, lib, pkgs, ... }: {
  home = {
    homeDirectory = "/home/deck";
    stateVersion  = "22.11";
    username      = lib.mkForce "deck";
  };

  imports = [
    ./home-manager
    ./home-manager/fish
    ./home-manager/lf
    ./home-manager/kitty.nix
    ./home-manager/neovim
    ./home-manager/direnv.nix
    ./home-manager/qutebrowser
  ];

  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;
}
