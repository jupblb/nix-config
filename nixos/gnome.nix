{ lib, pkgs, ... }: {
  environment = {
    gnome.excludePackages = with pkgs.gnome; [
      baobab cheese epiphany gedit gnome-calculator gnome-calendar gnome-clocks
      gnome-contacts gnome-logs gnome-maps gnome-music gnome-shell-extensions
      pkgs.gnome-tour gnome-weather pkgs.gnome-connections simple-scan yelp
    ];
    systemPackages        =
      let
        extensions = with pkgs.gnomeExtensions;
          [ just-perfection removable-drive-menu ];
        packages   = with pkgs; [ gnome-firmware ];
      in extensions ++ packages;
  };

  programs = {
    geary.enable          = false;
    gnome-disks.enable    = false;
    gnome-terminal.enable = false;
  };

  services = {
    dleyna-renderer.enable = false;

    dleyna-server.enable = false;

    gnome = {
      evolution-data-server.enable   = lib.mkForce false;
      gnome-browser-connector.enable = false;
      gnome-initial-setup.enable     = false;
      gnome-remote-desktop.enable    = false;
      rygel.enable                   = false;
    };

    power-profiles-daemon.enable = false;

    telepathy.enable = false;

    xserver = {
      enable               = true;
      desktopManager.gnome = { enable = true; };
      displayManager       = {
        autoLogin  = { enable = true; user = "jupblb"; };
        gdm.enable = true;
      };
    };
  };
}
