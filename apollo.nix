{ config, lib, pkgs, ... }: {
  home = {
    activation    = {
      linkDesktopApplications =
        lib.hm.dag.entryAfter [ "writeBoundary" "createXdgUserDirectories" ] ''
          $DRY_RUN_CMD ln -sfn \
            ${config.home.homeDirectory}/.nix-profile/share/applications \
            ${config.xdg.dataHome}/applications/home-manager
        '';
    };
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
  ];

  nixGl.packages = with pkgs; [ kitty ];

  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;
}
