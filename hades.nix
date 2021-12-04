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

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-uuid/9E04-A8F9";
    "/boot".fsType = "vfat";
  };

  fonts.enableDefaultFonts = true;
  fonts.fonts              = with pkgs; [ pragmata-pro ];

  hardware = {
    bluetooth.enable = true;

    cpu.intel.updateMicrocode = true;

    opengl = {
      driSupport      = true;
      enable          = true;
      extraPackages   = with pkgs; [ amdvlk libvdpau-va-gl vaapiVdpau ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };

    pulseaudio = {
      enable       = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package      = pkgs.pulseaudioFull;
    };
  };

  home-manager.users.jupblb = {
    home.stateVersion = "20.03";

    programs = {
      firefox        = {
        profiles."jupblb".settings = {
          "gfx.webrender.enabled"               = true;
          "widget.wayland-dmabuf-vaapi.enabled" = true;
        };
        package                    = pkgs.firefox-wayland.override {
          cfg.enableGnomeExtensions = true;
        };
      };

      kitty.settings = {
        hide_window_decorations = "yes";
        linux_display_server    = "wayland";
      };
    };

    services = {
      dropbox.enable = true;

      gpg-agent = {
        enable         = true;
        pinentryFlavor = "gnome3";
      };

      spotifyd = {
        enable          = true;
        package         = pkgs.spotifyd.override {
          withMpris = true;
          withPulseAudio = true;
        };
        settings.global = {
          backend     = "pulseaudio";
          bitrate     = "320";
          device_name = "hades";
          password    = builtins.readFile ./config/spotify.key;
          use_mpris   = "true";
          username    = "mpkielbowicz@gmail.com";
        };
      };
    };
  };

  imports = [ ./common/nixos.nix ];

  networking.hostName              = "hades";
  networking.networkmanager.enable = true;

  programs = { steam.enable = true; };

  services = {
    gnome = {
      chrome-gnome-shell.enable    = true;
      core-utilities.enable        = false;
      gnome-online-accounts.enable = true;
      gnome-settings-daemon.enable = true;
      sushi.enable                 = true;
    };

    gvfs.enable = true;

    printing = {
      drivers = with pkgs; [ samsung-unified-linux-driver_1_00_37 ];
      enable  = true;
    };

    syncthing = {
      configDir           = "/home/jupblb/.config/syncthing";
      dataDir             = "/home/jupblb/.local/share/syncthing";
      cert                = toString ./config/syncthing/hades/cert.pem;
      folders             = {
        "jupblb/Documents".path = "/home/jupblb/Documents";
        "jupblb/Pictures".path  = "/home/jupblb/Pictures";
      };
      key                 = toString ./config/syncthing/hades/key.pem;
      user                = "jupblb";
    };

    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0aaa",\
        ATTR{authorized}="0"
    '';

    wakeonlan.interfaces = [ {
      interface = "eno2";
      method    = "magicpacket";
    } ];

    xserver = {
      enable                            = true;
      desktopManager.gnome.enable      = true;
      desktopManager.gnome.sessionPath = with pkgs.gnome3; [
        evince gnome-screenshot nautilus shotwell totem
      ];
      displayManager.autoLogin.enable   = true;
      displayManager.autoLogin.user     = "jupblb";
      displayManager.gdm.enable         = true;
      videoDrivers                      = [ "amdgpu" ];
    };
  };

  sound.enable = true;

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.stateVersion = "20.03";

  time.hardwareClockInLocalTime = true;

  users.users.jupblb.extraGroups = [ "lp" ];
}

