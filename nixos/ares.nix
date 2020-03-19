{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  boot.extraModprobeConfig           = "options snd_hda_intel power_save=1";
  boot.initrd.availableKernelModules = [ "ehci_pci" "ums_realtek" "sr_mod" ];

  environment.systemPackages = with pkgs.unstable; [ ferdi' sway' xwayland ];

  fileSystems."/".device     = "/dev/disk/by-label/nixos";
  fileSystems."/".fsType     = "xfs";
  fileSystems."/boot".device = "/dev/disk/by-label/boot";
  fileSystems."/boot".fsType = "vfat";

  hardware.opengl.extraPackages = with pkgs; [ intel-media-driver vaapiIntel' ];

  networking.hostName = "ares";

  nix.maxJobs = 8;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="d8:50:e6:03:5c:44", NAME="eth"
    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="70:18:8b:3f:58:47", NAME="wlp"
  '';

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.stateVersion = "19.09";
}
