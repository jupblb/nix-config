{ config, pkgs, ... }:

let
  sway'' = pkgs.unstable.sway'.override {
    withExtraPackages = true;
    withScaling       = true;
  };
in {
  boot = {
    initrd.availableKernelModules               = [
      "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"
    ];
    initrd.kernelModules                        = [ "amdgpu" ];
    kernel.sysctl."fs.inotify.max_user_watches" = 524288;
    kernel.sysctl."vm.swappiness"               = 20;
    kernelModules                               = [ "kvm-intel" ];
    kernelPackages                              = pkgs.linuxPackages_latest;
    loader.efi.canTouchEfiVariables             = true;
    loader.systemd-boot.enable                  = true;
    tmpOnTmpfs                                  = true;
  };

  console.font     = "ter-232n";
  console.packages = [ pkgs.terminus_font ];

  environment.systemPackages = with pkgs.unstable; [ dropbox-cli sway'' ];

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-label/boot";
    "/boot".fsType = "vfat";
    "/data".device = "/dev/disk/by-label/data";
    "/data".fsType = "ext4";
  };

  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.extraPackages      = with pkgs; [ libvdpau-va-gl vaapiVdpau ];
  hardware.pulseaudio.package        = pkgs.pulseaudioFull;

  imports = [ ./common.nix ];

  networking = {
    firewall.allowedTCPPorts = [ 111 2049 4000 4001 4002 5900 ];
    firewall.allowedUDPPorts = [ 111 2049 4000 4001 4002 5900 ];
    hostName                 = "hades";
    networkmanager.enable    = true;
  };

  nix.maxJobs = 12;

  services = {
    apcupsd.enable = true;
    apcupsd.configText = ''
      UPSCABLE usb
      UPSTYPE usb
      DEVICE
    '';

    fstrim.enable = true;

    mingetty.autologinUser = "jupblb";

    nfs = {
      server.enable     = true;
      server.exports    = ''
        /data/nfs *(rw,sync,insecure,nohide,crossmnt,fsid=0,subtree_check)
      '';
      server.lockdPort  = 4001;
      server.mountdPort = 4002;
      server.statdPort  = 4000;
    };

    transmission = {
      enable   = true;
      group    = "data";
      settings = {
        download-dir           = "/data/transmission";
        incomplete-dir         = "/data/transmission/.incomplete";
        incomplete-dir-enabled = true;
        ratio-limit            = 0;
        ratio-limit-enabled    = true;
        rpc-whitelist          = "127.0.0.1,192.168.*.*";
      };
    };

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="00:d8:61:50:ae:85", NAME="eth"
    '';
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.extraSystemBuilderCmds = with pkgs; ''
    mkdir -p $out/jdks
    ln -s ${openjdk8}  $out/jdks/openjdk8
    ln -s ${openjdk11} $out/jdks/openjdk11
  '';
  system.stateVersion = "19.09";

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
  systemd.services.dropbox = {
    after                        = [ "network.target" ];
    description                  = "Dropbox";
    environment.QML2_IMPORT_PATH = with pkgs.qt5; ''
      ${qtbase}${qtbase.qtQmlPrefix}
    '';
    environment.QT_PLUGIN_PATH   = with pkgs.qt5; ''
      ${qtbase}${qtbase.qtPluginPrefix}
    '';
    serviceConfig                = {
      ExecStart     = "${pkgs.dropbox}/bin/dropbox";
      ExecReload    = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      KillMode      = "control-group";
      Nice          = 10;
      PrivateTmp    = true;
      ProtectSystem = "full";
      Restart       = "on-failure";
      User          = "jupblb";
    };
    wantedBy                     = [ "default.target" ];
  };

  time.hardwareClockInLocalTime = true;

  users.groups.data.members = [ "jupblb" ];
}
