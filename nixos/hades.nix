{ config, pkgs, ... }:

let
  sway-scaled = pkgs.unstable.sway'.override { withScaling = true; };
  xresources  = pkgs.writeTextFile {
    name = "Xresources";
    text = ''
      Xcursor.size: 24
      Xcursor.theme: Paper
      Xft.dpi: 163
    '';
  };
in {
  imports = [ ./common.nix ];

  boot.initrd.availableKernelModules = [ "nvme" ];
  boot.initrd.kernelModules          = [ "amdgpu" ];
  boot.tmpOnTmpfs                    = true;

  console.font     = "ter-232n";
  console.packages = [ pkgs.terminus_font ];

  environment.etc."X11/xinit/xinitrc".text = ''
    xrdb -merge ${xresources}
    ${pkgs.feh}/bin/feh --bg-scale ${./misc/wallpaper.png}
    exec i3
  '';
  environment.systemPackages               = [ sway-scaled ];

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-label/boot";
    "/boot".fsType = "vfat";
    "/data".device = "/dev/disk/by-label/data";
    "/data".fsType = "ext4";
  };

  networking.firewall.allowedTCPPorts = [ 111 2049 4000 4001 4002 ];
  networking.firewall.allowedUDPPorts = [ 111 2049 4000 4001 4002 ];
  networking.hostName                 = "hades";

  nix.maxJobs = 12;

  services = {
    apcupsd.enable                       = true;
    apcupsd.configText                   = ''
      UPSCABLE usb
      UPSTYPE usb
      DEVICE
    '';
    mingetty.autologinUser               = "jupblb";
    nfs                                  = {
      server.enable     = true;
      server.exports    = ''
        /data/nfs *(rw,sync,insecure,nohide,crossmnt,fsid=0,subtree_check)
      '';
      server.lockdPort  = 4001;
      server.mountdPort = 4002;
      server.statdPort  = 4000;
    };
    transmission                         = {
      enable                          = true;
      group                           = "data";
      settings.download-dir           = "/data/transmission";
      settings.incomplete-dir         = "/data/transmission/.incomplete";
      settings.incomplete-dir-enabled = true;
      settings.rpc-whitelist          = "127.0.0.1,192.168.*.*";
    };
    udev.extraRules                      = ''
      ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="00:d8:61:50:ae:85", NAME="eth"
    '';
    xserver.displayManager.startx.enable = true;
    xserver.enable                       = true;
    xserver.layout                       = "pl";
    xserver.windowManager.i3.enable      = true;
    xserver.windowManager.i3.package     = pkgs.unstable.i3';
    xserver.videoDrivers                 = [ "amdgpu" ];
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.extraSystemBuilderCmds = with pkgs; ''
    mkdir -p $out/pkgs
    ln -s ${openjdk8} $out/pkgs/openjdk8
    ln -s ${openjdk} $out/pkgs/openjdk
  '';
  system.stateVersion           = "19.09";

  systemd.services.checkip = {
    after         = [ "network.target" ];
    description   = "Public IP checker";
    script        = "${pkgs.curl}/bin/curl ipinfo.io/ip > /data/Dropbox/ip.txt";
    serviceConfig = {
      ProtectSystem = "full";
      Type          = "oneshot";
      User          = "jupblb";
    };
    startAt       = "*:0/15";
  };

  time.hardwareClockInLocalTime = true;

  users.groups.data.members = [ "jupblb" ];
}
