{ config, pkgs, ... }:

{
  boot = {
    initrd.availableKernelModules   = [
      "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"
    ];
    initrd.kernelModules            = [ "amdgpu" ];
    kernelPackages                  = pkgs.linuxPackages_latest;
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable      = true;
  };

  environment.systemPackages = with pkgs; [ dropbox-cli ];

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-label/boot";
    "/boot".fsType = "vfat";
    "/data".device = "/dev/disk/by-label/data";
    "/data".fsType = "ext4";
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl.extraPackages      = with pkgs; [ libvdpau-va-gl vaapiVdpau ];
  };

  home-manager.users.jupblb = import ../home.nix;

  imports = [
    <home-manager/nixos>
    ./common.nix
  ];

  networking = {
    firewall.allowedTCPPorts = [ 111 2049 4000 4001 4002 ];
    firewall.allowedUDPPorts = [ 111 2049 4000 4001 4002 ];
    hostName                 = "hades";
    networkmanager.enable    = true;
  };

  nix.maxJobs = 12;

  services = {
    apcupsd.enable     = true;
    apcupsd.configText = ''
      UPSCABLE usb
      UPSTYPE usb
      DEVICE
    '';

    fstrim.enable = true;

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
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0a12", ATTRS{idProduct}=="0001", ATTR{authorized}="0"
    '';

    wakeonlan.interfaces = [ {
      interface = "eno2";
      method    = "magicpacket";
    } ];
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  system.stateVersion = "19.09";

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
