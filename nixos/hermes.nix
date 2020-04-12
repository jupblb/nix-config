{ config, pkgs, ... }:

let
  chromium-firmware = pkgs.fetchgit {
    url    = "https://chromium.googlesource.com/chromiumos/third_party/linux-firmware";
    rev    = "6e5869c8ea7679009c8f8a301153face63d6bfd4";
    sha256 = "0hd5qkj5srliplqk2sq0zjhs1smfpkvgjhb914aql0aqmfhr7bc9";
  };
  sway''            = pkgs.unstable.sway'.override {
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
  boot.initrd.kernelModules            = [ "i915" ];
  boot.kernelPackages                  = pkgs.linuxPackages_latest;
  boot.kernelParams                    = [
    "reboot=pci" "i915.enable_guc=2" "inte_idle.max_cstate=1" "i915.enable_dc=0"
  ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable      = true;
  boot.tmpOnTmpfs                      = true;

  console.font     = "ter-232n";
  console.packages = [ pkgs.terminus_font ];

  environment.systemPackages = with pkgs.unstable; [ sway'' ];
  environment.variables      = { MESA_LOADER_DRIVER_OVERRIDE = "iris"; };

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-uuid/7E3B-F184";
    "/boot".fsType = "vfat";
  };

  hardware.cpu.intel.updateMicrocode = true;
  hardware.firmware                  = [
    (pkgs.runCommandNoCC "intel-wifi" {} ''
      mkdir -p $out/lib/firmware
      cp ${chromium-firmware}/iwlwifi-* $out/lib/firmware/
      ln -s $out/lib/firmware/iwlwifi-Qu-c0-hr-b0-50.ucode \
        $out/lib/firmware/iwlwifi-Qu-b0-hr-b0-50.ucode
    '')
  ];
  hardware.opengl.package            = (pkgs.mesa.override {
    galliumDrivers = [ "nouveau" "virgl" "swrast" "iris" ];
  }).drivers;
  hardware.opengl.extraPackages      = with pkgs; [
    intel-media-driver libvdpau-va-gl vaapiIntel' vaapiVdpau
  ];
  hardware.pulseaudio.package        = pkgs.pulseaudioFull;

  networking.firewall.allowedTCPPorts = [ 5900 ];
  networking.firewall.allowedUDPPorts = [ 5900 ];
  networking.hostName                 = "hermes";
  networking.networkmanager.enable    = true;

  nix.buildMachines = [ {
    hostName = "hades";
    system   = "x86_64-linux";
    maxJobs  = 1;    
  } ];
  nix.distributedBuilds = true;
  nix.maxJobs = 8;

  powerManagement.cpuFreqGovernor = "performance";

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
