{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  boot.extraModprobeConfig           = "options snd_hda_intel power_save=1";
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules          = [ "amdgpu" ];
  boot.tmpOnTmpfs                    = true;

  console.font     = "ter-232n";
  console.packages = [ pkgs.terminus_font ];

  environment.etc."sway/config".text       = "output * scale 2";
  environment.etc."X11/xinit/xinitrc".text = "xrdb -merge ${./misc/wm/Xresources-pipux}";

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-label/boot";
    "/boot".fsType = "vfat";
    "/data".device = "/dev/disk/by-label/data";
    "/data".fsType = "ext4";
  };

  hardware.opengl.extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];

  networking.firewall.allowedTCPPorts = [ 111 2049 4000 4001 4002 ];
  networking.firewall.allowedUDPPorts = [ 111 2049 4000 4001 4002 ];
  networking.hostName                 = "pipux";

  nix.maxJobs = 12;

  services = {
    apcupsd.enable                  = true;
    apcupsd.configText              = ''
      UPSCABLE usb
      UPSTYPE usb
      DEVICE
    '';
    fstrim.enable                   = true;
    mingetty.autologinUser          = "jupblb";
    nfs                             = {
      server.enable     = true;
      server.exports    = "/data/nfs *(rw,sync,insecure,nohide,crossmnt,fsid=0,subtree_check)";
      server.lockdPort  = 4001;
      server.mountdPort = 4002;
      server.statdPort  = 4000;
    };
    transmission                    = {
      enable                          = true;
      group                           = "data";
      settings.download-dir           = "/data/transmission";
      settings.incomplete-dir         = "/data/transmission/.incomplete";
      settings.incomplete-dir-enabled = true;
      settings.rpc-whitelist          = "127.0.0.1,192.168.*.*";
    };
    udev.extraRules                 = ''
      ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="00:d8:61:50:ae:85", NAME="eth"
      ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="34:29:8f:73:aa:fd", NAME="ethusb"
    '';
    xserver.windowManager.i3.enable = true;
    xserver.videoDrivers            = [ "amdgpu" ];
  };

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
