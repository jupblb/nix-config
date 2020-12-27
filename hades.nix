{ config, pkgs, ... }:

{
  boot = {
    initrd.availableKernelModules   = [
      "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"
    ];
    initrd.kernelModules            = [ "amdgpu" ];
    kernelPackages                  = pkgs.linuxPackages_latest;
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable      = true;
  };

  environment.systemPackages = with pkgs; [ mpv ];

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-uuid/9E04-A8F9";
    "/boot".fsType = "vfat";
  };

  fonts.enableDefaultFonts = true;
  fonts.fonts              = with pkgs; [ vistafonts ];

  hardware = {
    cpu.intel.updateMicrocode = true;

    opengl = {
      driSupport      = true;
      extraPackages   = with pkgs; [ amdvlk libvdpau-va-gl vaapiVdpau ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };
  };

  home-manager.users.jupblb = {
    home.stateVersion = "20.03";

    imports = [ ./common/home.nix ];

    nixpkgs.config.packageOverrides = _:
      let t = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      in (import (fetchTarball t) {});

    programs = {
      firefox.enableGnomeExtensions = true;
      firefox.package               = pkgs.firefox-wayland;
      kitty.settings                = { hide_window_decorations = "yes"; };
    };

    services.dropbox.enable = true;
  };

  imports =
    let
      url = "https://github.com/nix-community/home-manager/archive/${tar}";
      tar = "release-20.09.tar.gz";
    in [ "${fetchTarball url}/nixos" ./common/nixos.nix ];

  networking.hostName              = "hades";
  networking.networkmanager.enable = true;

  nix.maxJobs = 12;

  programs.steam.enable = true;

  services = {
    fstrim.enable = true;

    gnome3 = {
      chrome-gnome-shell.enable    = true;
      core-utilities.enable        = false;
      gnome-online-accounts.enable = true;
      gnome-settings-daemon.enable = true;
      sushi.enable                 = true;
    };

    gvfs.enable = true;

    syncthing = {
      configDir           = "/home/jupblb/.config/syncthing";
      dataDir             = "/home/jupblb/.local/share/syncthing";
      declarative.folders = {
        "/home/jupblb/Syncthing" = {
          devices        = [ "iris" ];
          id             = "jupblb";
          rescanInterval = 180;
        };
        "/home/jupblb/Workspace" = {
          devices        = [ "iris" ];
          id             = "jupblb-workspace";
          rescanInterval = 180;
        };
      };
      user                = "jupblb";
    };

    wakeonlan.interfaces = [ {
      interface = "eno2";
      method    = "magicpacket";
    } ];

    xserver = {
      enable                            = true;
      desktopManager.gnome3.enable      = true;
      desktopManager.gnome3.sessionPath = with pkgs.gnome3; [
        gnome-screenshot nautilus shotwell
      ];
      displayManager.autoLogin.enable   = true;
      displayManager.autoLogin.user     = "jupblb";
      displayManager.gdm.enable         = true;
      videoDrivers                      = [ "amdgpu" ];
    };
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.stateVersion = "20.03";

  time.hardwareClockInLocalTime = true;

  users.users.jupblb.shell = pkgs.fish;
}

