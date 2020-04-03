{ config, pkgs, ... }:

let
  sway = pkgs.unstable.sway'.override { withScaling = true; };
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ./common.nix
  ];

  boot.consoleLogLevel                   = 7;
  boot.kernelPackages                    = pkgs.linuxPackages_rpi4;
  boot.loader.grub.enable                = false;
  boot.loader.raspberryPi.enable         = true;
  boot.loader.raspberryPi.firmwareConfig = ''
    disable_overscan=1
    dtparam=audio=on
    gpu_mem=256
  '';
  boot.loader.raspberryPi.version        = 4;

  console.font     = "ter-232n";
  console.packages = [ pkgs.terminus_font ];

  environment.systemPackages = [ sway ];

  fileSystems."/".device     = "/dev/disk/by-label/NIXOS_SD";
  fileSystems."/".fsType     = "ext4";
  fileSystems."/boot".device = "/dev/disk/by-label/FIRMWARE";
  fileSystems."/boot".fsType = "vfat";

  hardware.deviceTree.base         = pkgs.device-tree_rpi;
  hardware.deviceTree.overlays     = [ "${pkgs.device-tree_rpi.overlays}/vc4-fkms-v3d.dtbo" ];
  hardware.opengl.setLdLibraryPath = true;
  hardware.opengl.package          = pkgs.mesa_drivers;

  networking.hostName = "iris";

  nix.maxJobs = 4;

  powerManagement.cpuFreqGovernor = "ondemand";

  services.mingetty.autologinUser = "jupblb";
}
