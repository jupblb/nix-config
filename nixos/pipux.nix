{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  boot.kernelModules                   = [ "kvm-intel" ];
  boot.kernelParams                    = [ "mitigations=off" "no_stf_barrier" "noibpb" "noibrs" ];
  boot.initrd.availableKernelModules   = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernel.sysctl                   = { "fs.inotify.max_user_watches" = 524288; "vm.swappiness" = 20; };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable              = false;
  boot.loader.systemd-boot.enable      = true;

  fileSystems."/"     = { 
    device = "/dev/disk/by-uuid/ddab3afa-579c-4742-ac66-7645aaf4669a";
    fsType = "f2fs";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2E0E-8F9D";
    fsType = "vfat";
  };
  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/388c2c36-0f5f-45f9-b0cd-b5b9e8fe8211";
    fsType = "ext4";
  };

  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.enable             = true;
  hardware.opengl.extraPackages      = with pkgs; [
    vaapiIntel' vaapiVdpau libvdpau-va-gl intel-media-driver intel-ocl 
  ];
  hardware.pulseaudio.enable         = true;

  i18n.consoleFont = "${pkgs.terminus_font}/share/consolefonts/ter-232n.psf.gz";

  networking.defaultGateway                      = "192.168.1.1";
  networking.firewall.enable                     = false;
  networking.hostName                            = "pipux";
  networking.interfaces.enp0s31f6.ipv4.addresses = [ { address = "192.168.1.2"; prefixLength = 24; } ];
  networking.wireless.enable                     = false;

  nix.maxJobs = 12;

  powerManagement.powertop.enable = true;

  services.apcupsd.enable          = true;
  services.apcupsd.configText      = ''
    UPSCABLE usb
    UPSTYPE usb
    DEVICE
  '';
  services.fstrim.enable         = true;
  services.nfs.server.enable     = true;
  services.nfs.server.exports    = "/data/nfs 192.168.1.2/24(rw,sync,insecure,nohide,crossmnt,fsid=0,subtree_check)";
  services.transmission.enable   = true;
  services.transmission.group    = "data";
  services.transmission.settings = { 
    download-dir           = "/data/transmission";
    incomplete-dir         = "/data/transmission/.incomplete";
    incomplete-dir-enabled = true;
    rpc-whitelist          = "127.0.0.1,192.168.*.*";
  };

  sound.enable = true;

  swapDevices = [ { device = "/dev/disk/by-uuid/7a705c18-3066-4c7b-a989-3b0cc114934e"; } ];

  system.stateVersion = "19.09";

  users.groups.data.members = [ "jupblb" ];

  virtualisation.libvirtd.enable             = false;
  virtualisation.libvirtd.extraConfig        = ''
    listen_tls = 0
    listen_tcp = 1
    auth_tcp   = "none"
  '';
  virtualisation.libvirtd.onBoot             = "ignore";
  virtualisation.libvirtd.onShutdown         = "shutdown";
  virtualisation.libvirtd.qemuOvmf           = true;
  virtualisation.libvirtd.qemuPackage        = pkgs.qemu_kvm;
  virtualisation.libvirtd.qemuVerbatimConfig = ''
    nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
  '';
}
