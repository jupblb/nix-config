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

  environment.systemPackages = with pkgs; [ dropbox-cli ];

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-uuid/9E04-A8F9";
    "/boot".fsType = "vfat";
  };

  fonts.enableDefaultFonts = true;
  fonts.fonts              = with pkgs; [ vistafonts ];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.extraPackages      = with pkgs; [ libvdpau-va-gl vaapiVdpau ];

  home-manager.users.jupblb = {
    home.stateVersion = "20.03";

    imports = [ ./common/home.nix ];

    nixpkgs.pkgs =
      let t = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      in import (fetchTarball t) {};

    programs = {
      fish.shellInit = ''
        if test -z "$DISPLAY"; and test (tty) = "/dev/tty1"; exec sway; end
      '';

      firefox.package = pkgs.firefox-wayland;

      i3status.enable        = true;
      i3status.enableDefault = true;
    };
  };

  imports = [ <home-manager/nixos> ./common/nixos.nix ];

  networking.hostName              = "hades";
  networking.networkmanager.enable = true;

  nix.maxJobs = 12;

  programs.sway = {
    enable               = true;
    extraOptions         = [
      "-c" "${pkgs.callPackage ./config/sway/config.nix {}}"
    ];
    extraPackages        = with pkgs; [ imv mpv pavucontrol wl-clipboard ];
    extraSessionCommands = builtins.readFile ./config/sway/sway.sh;
    wrapperFeatures.gtk  = true;
  };

  security.pam.services.swaylock.text = "auth include login";

  services = {
    apcupsd.enable     = true;
    apcupsd.configText = ''
      UPSCABLE usb
      UPSTYPE usb
      DEVICE
    '';

    fstrim.enable = true;

    wakeonlan.interfaces = [ {
      interface = "eno2";
      method    = "magicpacket";
    } ];
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.stateVersion = "20.03";

  systemd.services.dropbox = {
    after                        = [ "network.target" ];
    description                  = "Dropbox";
    environment.QML2_IMPORT_PATH = with pkgs.qt5.qtbase; "${bin}${qtQmlPrefix}";
    environment.QT_PLUGIN_PATH   = with pkgs.qt5.qtbase; "${bin}${qtQmlPrefix}";
    serviceConfig                = {
      ExecStart     = "${pkgs.dropbox}/bin/dropbox";
      ExecReload    = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      KillMode      = "control-group";
      Nice          = 10;
      PrivateTmp    = true;
      ProtectSystem = "full";
      Restart       = "on-failure";
      User          = "jupblb";
    };
    wantedBy                     = [ "default.target" ];
  };

  time.hardwareClockInLocalTime = true;

  users.users.jupblb.shell = pkgs.fish;
}

