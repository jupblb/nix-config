{ lib, pkgs, ... }: {
  environment = {
    gnome.excludePackages = with pkgs.gnome; [
      baobab cheese epiphany gedit gnome-calculator gnome-calendar gnome-clocks
      gnome-contacts gnome-logs gnome-maps gnome-music gnome-shell-extensions
      pkgs.gnome-tour gnome-weather pkgs.gnome-connections simple-scan totem
      yelp
    ];
    systemPackages        =
      let
        extensions = with pkgs.gnomeExtensions; [
          adjust-display-brightness compiz-windows-effect just-perfection
          removable-drive-menu
        ];
        packages   = with pkgs;
          [ ddcutil google-chrome-wayland gnome-firmware vlc ];
      in extensions ++ packages;
  };

  home-manager.users.jupblb = { config, lib, pkgs, ... }: {
    programs.kitty.settings = { linux_display_server = "wayland"; };

    services.gpg-agent.pinentryFlavor = "gnome3";
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
