{ pkgs, ... }: {
  environment = {
    gnome.excludePackages = with pkgs.gnome; [
      baobab cheese epiphany gedit gnome-calculator gnome-disk-utility
      gnome-logs gnome-music gnome-shell-extensions gnome-terminal
      pkgs.gnome-connections simple-scan yelp
    ];
    systemPackages        = with pkgs.gnomeExtensions;
      [ compiz-windows-effect hide-top-bar removable-drive-menu ];
  };

  services = {
    dleyna-renderer.enable = false;

    dleyna-server.enable = false;

    gnome = {
      chrome-gnome-shell.enable   = false;
      gnome-remote-desktop.enable = false;
      rygel.enable                = false;
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
