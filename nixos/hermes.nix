{ config, pkgs, ... }:

let
  sway'' = pkgs.unstable.sway'.override {
    withExtraPackages = true;
    withScaling       = true;
  };
in {
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ./common.nix
  ];

  boot.initrd.availableKernelModules               = [
    "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod"
  ];
  boot.kernelPackages                  = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable      = true;
  boot.tmpOnTmpfs                      = true;

  console.font     = "ter-232n";
  console.packages = [ pkgs.terminus_font ];

  environment.systemPackages = with pkgs.unstable; [ sway'' ];

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-uuid/7E3B-F184";
    "/boot".fsType = "vfat";
    "/data".device = "/dev/disk/by-label/data";
    "/data".fsType = "ext4";
  };

  hardware.opengl.extraPackages      = with pkgs; [
    intel-media-driver libvdpau-va-gl vaapiIntel' vaapiVdpau
  ];
  hardware.pulseaudio.package        = pkgs.pulseaudioFull;

  networking.firewall.allowedTCPPorts = [ 5900 ];
  networking.firewall.allowedUDPPorts = [ 5900 ];
  networking.hostName                 = "hermes";
  networking.networkmanager.enable    = true;

  nix.maxJobs = 8;

  powerManagement.cpuFreqGovernor = "powersave";

  services.fstrim.enable = true;

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.extraSystemBuilderCmds = with pkgs; ''
    mkdir -p $out/pkgs
    ln -s ${openjdk8} $out/pkgs/openjdk8
    ln -s ${openjdk} $out/pkgs/openjdk
  '';
  system.stateVersion           = "20.03";

  time.hardwareClockInLocalTime = true;
}
