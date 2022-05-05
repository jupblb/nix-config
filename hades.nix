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

  environment.systemPackages = with pkgs; [ _1password-gui ];

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
    home.stateVersion = "20.03";

    imports = [
      ./home-manager/direnv.nix
      ./home-manager/firefox
      ./home-manager/fish
      ./home-manager/go.nix
      ./home-manager/kitty
      ./home-manager/lf.nix
      ./home-manager/neovim
      ./home-manager/neovim/lsp.nix
      ./home-manager/starship.nix
      ./home-manager/zk
      ./home-manager/zoxide.nix
    ];

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
    };

    services = {
      dropbox.enable = true;

      gpg-agent = {
        enable         = true;
        pinentryFlavor = "gnome3";
      };
    };
  };

  imports = [ ./nixos ./nixos/apc.nix ./nixos/gnome.nix ./nixos/syncthing.nix ];

  networking.hostName = "hades";

  programs = { steam.enable = true; };

  services = {
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

    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0aaa",\
        ATTR{authorized}="0"
    '';
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

