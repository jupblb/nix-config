{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  boot.consoleLogLevel                   = 7;
  boot.kernelPackages                    = pkgs.linuxPackages_rpi4;
  boot.loader.grub.enable                = false;
  boot.loader.raspberryPi.enable         = true;
  boot.loader.raspberryPi.firmwareConfig = "gpu_mem=256";
  boot.loader.raspberryPi.version        = 4;

  fileSystems."/".device = "/dev/disk/by-label/NIXOS_SD";
  fileSystems."/".fsType = "ext4";

  hardware.deviceTree.base         = pkgs.device-tree_rpi;
  hardware.deviceTree.overlays     = [ "${pkgs.device-tree_rpi.overlays}/vc4-fkms-v3d.dtbo" ];
  hardware.opengl.setLdLibraryPath = true;
  hardware.opengl.package          = pkgs.mesa_drivers;
  
  nix.maxJobs = 2;

  powerManagement.cpuFreqGovernor = "ondemand";
}
