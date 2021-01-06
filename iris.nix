{ config, pkgs, ... }:

{
  boot = {
    blacklistedKernelModules = [ "brcmfmac" ];

    consoleLogLevel = 7;

    kernelPackages = pkgs.linuxPackages_rpi4;

    loader = {
      grub.enable                = false;
      raspberryPi.enable         = true;
      raspberryPi.firmwareConfig = ''
        disable_overscan=1
        dtparam=audio=on
        gpu_mem=192
      '';
      raspberryPi.version        = 4;
    };
  };

  environment.systemPackages = with pkgs; [ wol ];

  fileSystems = {
    "/".device     = "/dev/disk/by-label/NIXOS_SD";
    "/".fsType     = "ext4";
    "/boot".device = "/dev/disk/by-label/NIXOS_BOOT";
    "/boot".fsType = "vfat";
  };

  hardware = {
    opengl.setLdLibraryPath  = true;
    opengl.package           = pkgs.mesa_drivers;
  };

  imports = [ ./common/nixos.nix ];

  networking = {
    defaultGateway                 = "192.168.1.1";
    firewall.allowedTCPPorts       = [ 22067 22070 ];
    firewall.allowedUDPPorts       = [ 22067 22070 ];
    hostName                       = "iris";
    interfaces.eth0.ipv4.addresses = [
      { address = "192.168.1.3"; prefixLength = 24; }
    ];
    nameservers                    = [ "1.1.1.1" "8.8.8.8" ];
    wireless.enable                = false;
  };

  nix.maxJobs = 2;

  programs.gnupg.agent.pinentryFlavor = "curses";

  services.apcupsd.enable   = lib.mkForce false;
  services.syncthing.enable = lib.mkForce false;
}

