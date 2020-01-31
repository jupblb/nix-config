{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  boot = {
    extraModprobeConfig             = "options snd_hda_intel power_save=1";
    initrd.availableKernelModules   = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    kernel.sysctl                   = { 
      "fs.inotify.max_user_watches" = 524288;
      "vm.swappiness"               = 20; 
    };
    kernelParams                    = [ "mitigations=off" "no_stf_barrier" "noibpb" "noibrs" ];
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable      = true;
  };

  fileSystems."/".device     = "/dev/disk/by-label/nixos";
  fileSystems."/".fsType     = "xfs";
  fileSystems."/boot".device = "/dev/disk/by-label/boot";
  fileSystems."/boot".fsType = "vfat";
  fileSystems."/data".device = "/dev/disk/by-label/data";
  fileSystems."/data".fsType = "ext4";

  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.enable             = true;
  hardware.opengl.extraPackages      = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
  hardware.pulseaudio.enable         = true;

  i18n.consoleFont     = "ter-232n";
  i18n.consolePackages = [ pkgs.terminus_font ];

  networking.firewall.enable                = false;
  networking.hostName                       = "pipux";
  networking.wireless.enable                = false;

  nix.maxJobs = 12;

  services.acpid.enable            = true;
  services.apcupsd.enable          = true;
  services.apcupsd.configText      = ''
    UPSCABLE usb
    UPSTYPE usb
    DEVICE
  '';
  services.fstrim.enable         = true;
  services.nfs.server.enable     = true;
  services.nfs.server.exports    = "/data/nfs *(rw,sync,insecure,nohide,crossmnt,fsid=0,subtree_check)";
  services.transmission.enable   = true;
  services.transmission.group    = "data";
  services.transmission.settings = { 
    download-dir           = "/data/transmission";
    incomplete-dir         = "/data/transmission/.incomplete";
    incomplete-dir-enabled = true;
    rpc-whitelist          = "127.0.0.1,192.168.*.*";
  };
  services.udev.extraRules       = ''
    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="00:d8:61:50:ae:85", NAME="eth"
    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="34:29:8f:73:aa:fd", NAME="ethusb"
  '';
  services.xserver.videoDrivers  = [ "amdgpu" ];

  sound.enable = true;

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.stateVersion = "19.09";

  time.hardwareClockInLocalTime = true;
  time.timeZone                 = "Europe/Warsaw";

  users.groups.data.members     = [ "jupblb" ];
  users.groups.input.members    = [ "jupblb" ];
}
