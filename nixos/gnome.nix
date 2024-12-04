{ lib, pkgs, ... }: {
  environment = {
    gnome.excludePackages = with pkgs; [
      baobab cheese epiphany gnome-calculator gnome-calendar gnome-clocks
      gnome-contacts gnome-logs gnome-maps gnome-music gnome-shell-extensions
      gnome-tour gnome-weather gedit gnome-connections simple-scan totem yelp
    ];
    sessionVariables      = { NIXOS_OZONE_WL = "1"; };
    systemPackages        =
      let
        extensions = with pkgs.gnomeExtensions; [
          compiz-windows-effect just-perfection removable-drive-menu
        ];
        packages   = with pkgs; [
          ddcutil google-chrome gnome-firmware jellyfin-media-player vlc
          wl-clipboard
        ];
      in extensions ++ packages;
    variables             = {
      CHROME_EXECUTABLE = pkgs.lib.meta.getExe pkgs.google-chrome;
    };
  };

  home-manager.users.jupblb = { config, lib, pkgs, ... }: {
    programs = { kitty.settings.linux_display_server = "wayland"; };
    services = { gpg-agent.pinentryPackage = pkgs.pinentry-gnome3; };
  };

  programs = {
    dconf          = { enable = true; };
    geary          = { enable = false; };
    gnome-disks    = { enable = false; };
    gnome-terminal = { enable = false; };
  };

  services = {
    displayManager = { autoLogin = { enable = true; user = "jupblb"; }; };

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
      displayManager       = { gdm.enable = true; };
    };
  };

  systemd.services = {
    # https://github.com/NixOS/nixpkgs/issues/103746
    "getty@tty1".enable  = false;
    "autovt@tty1".enable = false;
  };
}
