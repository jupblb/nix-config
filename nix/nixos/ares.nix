{ config, pkgs, ... }:

{
  boot.initrd.availableKernelModules   = [
    "ahci"
    "ehci_pci"
    "sd_mod" "sr_mod"
    "ums_realtek" "usb_storage" "usbhid"
    "xhci_pci"
  ];
  boot.kernelPackages                  = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable      = true;

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-label/boot";
    "/boot".fsType = "vfat";
  };

  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.extraPackages      = with pkgs; [
    intel-media-driver libvdpau-va-gl vaapiIntel' vaapiVdpau
  ];

  imports = [ ./common.nix ];

  networking.hostName              = "ares";
  networking.networkmanager.enable = true;

  nix.maxJobs = 8;

  services.fstrim.enable = true;

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.stateVersion = "19.09";
}
