{ lib, pkgs, ... }: {
  boot = {
    consoleLogLevel = 0;
    initrd          = { systemd = { enable = true; }; };
    kernelParams    = [ "quiet" "udev.log_level=3" ];
    plymouth        = { enable = true; extraConfig = "DeviceScale=2"; };
  };

  environment = {
    gnome            = {
      excludePackages = with pkgs; [ cheese gnome-tour orca ];
    };
    sessionVariables = { NIXOS_OZONE_WL = "1"; };
    systemPackages   =
      let
        extensions = with pkgs.gnomeExtensions;
          [ compiz-windows-effect just-perfection removable-drive-menu
        ];
        packages   = with pkgs; [
          google-chrome gnome-firmware gnome-randr gnome-shell-extensions
          obsidian vlc wl-clipboard
        ];
      in extensions ++ packages;
    variables        = {
      CHROME_EXECUTABLE = pkgs.lib.meta.getExe pkgs.google-chrome;
    };
  };

  home-manager.users.jupblb = { pkgs, ... }: {
    programs = { kitty.settings.linux_display_server = "wayland"; };
    services = { gpg-agent.pinentryPackage = pkgs.pinentry-gnome3; };
  };

  programs = {
    dconf = { enable = true; };
  };

  services = {
    displayManager = { autoLogin = { enable = true; user = "jupblb"; }; };

    gnome = {
      core-utilities          = { enable = false; };
      core-os-services        = { enable = lib.mkForce false; };
      gnome-browser-connector = { enable = false; };
      gnome-initial-setup     = { enable = false; };
      gnome-remote-desktop    = { enable = false; };
      rygel                   = { enable = false; };
    };

    xserver = {
      enable         = true;
      desktopManager = { gnome = { enable = true; }; };
      displayManager = { gdm = { enable = true; }; };
    };
  };

  systemd.services = {
    # https://github.com/NixOS/nixpkgs/issues/103746
    "getty@tty1".enable  = false;
    "autovt@tty1".enable = false;
  };
}
