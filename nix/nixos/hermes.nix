{ config, pkgs, ... }:

let
  chromium-firmware = pkgs.fetchgit {
    url    = "https://chromium.googlesource.com/chromiumos/third_party/linux-firmware";
    rev    = "6e5869c8ea7679009c8f8a301153face63d6bfd4";
    sha256 = "0hd5qkj5srliplqk2sq0zjhs1smfpkvgjhb914aql0aqmfhr7bc9";
  };
in {
  boot = {
    initrd.availableKernelModules          = [
      "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod"
    ];
    kernelPackages                         = pkgs.linuxPackages_latest;
    kernelParams                           = [ "reboot=pci" ];
    loader.efi.canTouchEfiVariables        = true;
    loader.systemd-boot.configurationLimit = 3;
    loader.systemd-boot.enable             = true;
    tmpOnTmpfs                             = true;
  };

  console.font     = "ter-232n";
  console.packages = [ pkgs.terminus_font ];

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-uuid/7E3B-F184";
    "/boot".fsType = "vfat";
  };

  hardware = {
    bluetooth.enable          = true;
    cpu.intel.updateMicrocode = true;
    firmware                  = [
      (pkgs.runCommandNoCC "intel-wifi" {} ''
        mkdir -p $out/lib/firmware
        cp ${chromium-firmware}/iwlwifi-* $out/lib/firmware/
        ln -s $out/lib/firmware/iwlwifi-Qu-c0-hr-b0-50.ucode \
          $out/lib/firmware/iwlwifi-Qu-b0-hr-b0-50.ucode
      '')
    ];
    opengl.extraPackages      = with pkgs; [
      intel-media-driver libvdpau-va-gl vaapiIntel vaapiVdpau
    ];
    pulseaudio.package        = pkgs.pulseaudioFull;
  };

  home-manager.users.jupblb = (import ../home.nix);

  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ./common.nix
  ];

  networking = {
    firewall.allowedTCPPorts = [ 5900 ];
    firewall.allowedUDPPorts = [ 5900 ];
    hostName                 = "hermes";
    networkmanager.enable    = true;
  };

  nix.maxJobs = 8;

  powerManagement.cpuFreqGovernor = "ondemand";

  services.blueman.enable   = true;
  services.fstrim.enable    = true;
  services.logind.lidSwitch = "ignore";

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.extraSystemBuilderCmds = with pkgs; ''
    mkdir -p $out/jdks
    ln -s ${openjdk8}  $out/jdks/openjdk8
    ln -s ${openjdk11} $out/jdks/openjdk11
  '';
  system.stateVersion = "20.03";

  time.hardwareClockInLocalTime = true;
}
