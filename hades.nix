{ config, pkgs, ... }:

{
  boot = {
    initrd.availableKernelModules   = [
      "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"
    ];
    initrd.kernelModules            = [ "amdgpu" ];
    kernelPackages                  = pkgs.linuxPackages_latest;
    kernelParams                    = [ "mitigations=off" ];
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable      = true;
  };

  environment = {
    gnome.excludePackages = with pkgs.gnome; [
      baobab cheese epiphany gedit gnome-calculator gnome-disk-utility
      gnome-logs gnome-music gnome-shell-extensions gnome-terminal
      pkgs.gnome-connections simple-scan yelp
    ];
    systemPackages        = with pkgs.gnomeExtensions;
      [ compiz-windows-effect hide-top-bar removable-drive-menu ];
  };

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-uuid/9E04-A8F9";
    "/boot".fsType = "vfat";
  };

  fonts.enableDefaultFonts = true;
  fonts.fonts              = with pkgs; [ pragmata-pro ];

  hardware = {
    bluetooth.enable   = true;
    cpu.intel          = { updateMicrocode = true; };
    opengl             = {
      driSupport      = true;
      enable          = true;
      extraPackages   = with pkgs; [ amdvlk libvdpau-va-gl vaapiVdpau ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };
    pulseaudio         = {
      enable       = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package      = pkgs.pulseaudioFull;
    };
    video.hidpi.enable = true;
  };

  home-manager.users.jupblb = {
    home = {
      packages     = with pkgs; [ _1password-gui ];
      stateVersion = "20.03";
    };

    programs = {
      firefox        = {
        profiles."jupblb".settings = {
          "gfx.webrender.enabled"               = true;
          "widget.wayland-dmabuf-vaapi.enabled" = true;
        };
        package                    = pkgs.firefox-wayland.override {
          cfg.enableTridactylNative = true;
        };
      };

      kitty.settings = {
        hide_window_decorations = "yes";
        linux_display_server    = "wayland";
      };

      neovim.extraConfig = "autocmd VimEnter * GkeepLogin";
    };

    services = {
      dropbox.enable = true;

      gpg-agent = {
        enable         = true;
        pinentryFlavor = "gnome3";
      };
    };
  };

  imports = [ ./common/nixos.nix ];

  networking.hostName = "hades";

  programs = { steam.enable = true; };

  services = {
    dleyna-renderer.enable = false;

    dleyna-server.enable = false;

    gnome = {
      chrome-gnome-shell.enable   = false;
      gnome-remote-desktop.enable = false;
      rygel.enable                = false;
    };

    power-profiles-daemon.enable = false;

    printing = {
      drivers = with pkgs; [ samsung-unified-linux-driver_1_00_37 ];
      enable  = true;
    };

    syncthing = {
      configDir = "/home/jupblb/.config/syncthing";
      dataDir   = "/home/jupblb/.local/share/syncthing";
      cert      = toString ./config/syncthing/hades/cert.pem;
      folders   = {
        "jupblb/Documents" = {
          enable = true;
          path   = "/home/jupblb/Documents";
        };
        "jupblb/Pictures"  = {
          enable = true;
          path   = "/home/jupblb/Pictures";
        };
      };
      key       = toString ./config/syncthing/hades/key.pem;
      user      = "jupblb";
    };

    telepathy.enable = false;

    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0aaa",\
        ATTR{authorized}="0"
    '';

    xserver = {
      enable               = true;
      desktopManager.gnome = { enable = true; };
      displayManager       = {
        autoLogin  = { enable = true; user = "jupblb"; };
        gdm.enable = true;
      };
    };
  };

  sound.enable = true;

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.stateVersion = "20.03";

  systemd.services = {
    # https://github.com/NixOS/nixpkgs/issues/103746
    "getty@tty1".enable  = false;
    "autovt@tty1".enable = false;
  };

  time.hardwareClockInLocalTime = true;

  users.users.jupblb.extraGroups = [ "lp" ];
}

