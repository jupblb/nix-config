{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  boot = {
    blacklistedKernelModules        = [ "amdgpu" "snd_hda_codec_hdmi" "iwlwifi" ];
    extraModprobeConfig             = ''
      options i915 enable_guc=2
      options i915 enable_gvt=0
      options i915 enable_fbc=1
      options snd_hda_intel power_save=1
      options vfio-pci ids=8086:a370,1002:67df,1002:aaf0
    '';
    initrd.availableKernelModules   = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" "i915" ];
    kernel.sysctl                   = { 
      "fs.inotify.max_user_watches" = 524288;
      "vm.swappiness"               = 20; 
      "kernel.panic"                = 5;
      "kernel.nmi_watchdog"         = 0;
    };
    kernelModules                   = [ "kvm-intel" "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
    kernelParams                    = [
      "intel_iommu=on"
      "iommu=pt"
      "mitigations=off"
      "no_stf_barrier"
      "noibpb"
      "noibrs"
      "nowatchog"
      "pcie_acs_override=id:8086:a370"
      "autosuspend=-1"
    ];
    kernelPatches                   = [ { name = "add-acs-overrides"; patch = ./scripts/add-acs-overrides.patch; } ];
    loader.efi.canTouchEfiVariables = true;
    loader.grub.enable              = false;
    loader.systemd-boot.enable      = true;
  };

  fileSystems."/".device     = "/dev/disk/by-label/nixos";
  fileSystems."/".fsType     = "f2fs";
  fileSystems."/boot".device = "/dev/disk/by-label/boot";
  fileSystems."/boot".fsType = "vfat";
  fileSystems."/data".device = "/dev/disk/by-label/data";
  fileSystems."/data".fsType = "ext4";

  hardware.bluetooth.enable          = false;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.enable             = true;
  hardware.opengl.extraPackages      = with pkgs; [
    vaapiIntel' vaapiVdpau libvdpau-va-gl intel-media-driver intel-ocl 
  ];
  hardware.pulseaudio.enable         = true;

  i18n.consoleFont     = "ter-232n";
  i18n.consolePackages = [ pkgs.terminus_font ];

  networking.defaultGateway                 = "192.168.1.1";
  networking.firewall.enable                = false;
  networking.hostName                       = "pipux";
  networking.interfaces.eno2.ipv4.addresses = [ { address = "192.168.1.2"; prefixLength = 24; } ];
  networking.wireless.enable                = false;

  nix.maxJobs = 12;

  services.apcupsd.enable          = true;
  services.apcupsd.configText      = ''
    UPSCABLE usb
    UPSTYPE usb
    DEVICE
  '';
  services.fstrim.enable         = true;
  services.nfs.server.enable     = true;
  services.nfs.server.exports    = ''
    /data/nfs 192.168.1.2/24(rw,sync,insecure,nohide,crossmnt,fsid=0,subtree_check)
  '';
  services.transmission.enable   = true;
  services.transmission.group    = "data";
  services.transmission.settings = { 
    download-dir           = "/data/transmission";
    incomplete-dir         = "/data/transmission/.incomplete";
    incomplete-dir-enabled = true;
    rpc-whitelist          = "127.0.0.1,192.168.*.*";
  };
  services.udev.extraRules       = ''
    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{idVendor}=="8087", ATTR{idProduct}=="0aaa", ATTR{power/control}="on"
  '';

  sound.enable = true;

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.stateVersion = "19.09";

  users.groups.data.members     = [ "jupblb" ];
  users.groups.input.members    = [ "jupblb" ];
  users.groups.libvirtd.members = [ "root" "jupblb"];

  virtualisation.libvirtd.enable             = true;
  virtualisation.libvirtd.onBoot             = "ignore";
  virtualisation.libvirtd.onShutdown         = "shutdown";
  virtualisation.libvirtd.qemuOvmf           = true;
  virtualisation.libvirtd.qemuPackage        = pkgs.qemu_kvm;
  virtualisation.libvirtd.qemuVerbatimConfig = ''
    cgroup_device_acl = [
      "/dev/full",
      "/dev/hpet",
      "/dev/kqemu",
      "/dev/kvm",
      "/dev/null",
      "/dev/ptmx",
      "/dev/random",
      "/dev/rtc",
      "/dev/urandom",
      "/dev/zero",
      "/dev/input/by-id/usb-Ultimate_Gadget_Laboratories_Ultimate_Hacking_Keyboard-if01-event-kbd",
      "/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-mouse"
    ]
    nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
  '';
}
