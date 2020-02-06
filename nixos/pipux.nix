{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  boot.extraModprobeConfig           = "options snd_hda_intel power_save=1";
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules          = [ "amdgpu" ];
  boot.tmpOnTmpfs                    = true;

  console.font     = "ter-232n";
  console.packages = [ pkgs.terminus_font ];

  environment.etc."sway/config".text          = "output * scale 2";
  environment.etc."X11/xinit/xinitrc".text    = "xrdb -merge -I$HOME /etc/X11/xinit/Xresources";
  environment.etc."X11/xinit/Xresources".text = ''
    Xcursor.size: 24
    Xcursor.theme: Paper
    Xft.dpi: 192
  '';
  environment.systemPackages                  = with pkgs.unstable; [ neovim'' ];

  fileSystems."/".device     = "/dev/disk/by-label/nixos";
  fileSystems."/".fsType     = "xfs";
  fileSystems."/boot".device = "/dev/disk/by-label/boot";
  fileSystems."/boot".fsType = "vfat";
  fileSystems."/data".device = "/dev/disk/by-label/data";
  fileSystems."/data".fsType = "ext4";

  hardware.bluetooth.enable     = true;
  hardware.bluetooth.package    = pkgs.bluezFull;
  hardware.opengl.extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
  hardware.pulseaudio.package   = pkgs.pulseaudioFull;

  networking.hostName = "pipux";

  nix.maxJobs = 12;

  services.apcupsd.enable                  = true;
  services.apcupsd.configText              = ''
    UPSCABLE usb
    UPSTYPE usb
    DEVICE
  '';
  services.fstrim.enable                   = true;
  services.nfs.server.enable               = true;
  services.nfs.server.exports              = "/data/nfs *(rw,sync,insecure,nohide,crossmnt,fsid=0,subtree_check)";
  services.transmission.enable             = true;
  services.transmission.group              = "data";
  services.transmission.settings           = { 
    download-dir           = "/data/transmission";
    incomplete-dir         = "/data/transmission/.incomplete";
    incomplete-dir-enabled = true;
    rpc-whitelist          = "127.0.0.1,192.168.*.*";
  };
  services.udev.extraRules                 = ''
    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="00:d8:61:50:ae:85", NAME="eth"
    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="34:29:8f:73:aa:fd", NAME="ethusb"
  '';
  services.xserver.windowManager.i3.enable = true;
  services.xserver.videoDrivers            = [ "amdgpu" ];

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.extraSystemBuilderCmds = with pkgs.unstable; ''
    mkdir -p $out/pkgs
    ln -s ${openjdk8 } $out/pkgs/openjdk8
    ln -s ${openjdk  } $out/pkgs/openjdk
  '';
  system.stateVersion           = "19.09";

  time.hardwareClockInLocalTime = true;

  users.groups.data.members = [ "jupblb" ];
}
