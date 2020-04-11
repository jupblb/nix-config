{ config, pkgs, ... }:

let
  sway'' = pkgs.unstable.sway'.override {
    withExtraPackages = true;
    withScaling       = true;
  };
in {
  imports = [ ./common.nix ];

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
#   "/boot".device = "/dev/disk/by-label/boot";
#   "/boot".fsType = "vfat";
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
