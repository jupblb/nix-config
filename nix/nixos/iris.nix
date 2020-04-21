{ config, pkgs, ... }:

let
  serverIP = "192.168.1.7";
in {
  boot = {
    blacklistedKernelModules          = [ "brcmfmac" ];
    consoleLogLevel                   = 7;
    kernelPackages                    = pkgs.linuxPackages_rpi4;
    loader.grub.enable                = false;
    loader.raspberryPi.enable         = true;
    loader.raspberryPi.firmwareConfig = ''
      disable_overscan=1
      dtparam=audio=on
      gpu_mem=256
    '';
    loader.raspberryPi.version        = 4;
  };

  console.font     = "ter-232n";
  console.packages = [ pkgs.terminus_font ];

  docker-containers.pihole = {
    image              = "pihole/pihole:latest";
    volumes            = [
      "/var/lib/pihole/:/etc/pihole/"
      "/var/lib/dnsmasq/.d:/etc/dnsmasq.d/"
    ];
    environment        = {
      ServerIP    = serverIP;
      WEBPASSWORD = "changeme";
      TZ          = "Europe/Warsaw";
    };
    extraDockerOptions = [
      "--cap-add=NET_ADMIN"
      "--cap-add=NET_BIND_SERVICE"
      "--cap-add=NET_RAW"
      "--dns=127.0.0.1"
      "--dns=1.1.1.1"
      "--net=host"
      "--privileged"
    ];
    workdir            = "/var/lib/pihole/";
  };

  fileSystems."/".device     = "/dev/disk/by-label/NIXOS_SD";
  fileSystems."/".fsType     = "ext4";
  fileSystems."/boot".device = "/dev/disk/by-label/FIRMWARE";
  fileSystems."/boot".fsType = "vfat";

  hardware = {
    deviceTree.base         = pkgs.device-tree_rpi;
    deviceTree.overlays     = [
      "${pkgs.device-tree_rpi.overlays}/vc4-fkms-v3d.dtbo"
    ];
    opengl.setLdLibraryPath = true;
    opengl.package          = pkgs.mesa_drivers;
  };

  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ./common.nix
  ];

  networking = {
    defaultGateway                 = "192.168.1.1";
    firewall.allowedTCPPorts       = [ 53 67 80 443 ];
    firewall.allowedUDPPorts       = [ 53 67 80 443 ];
    hostName                       = "iris";
    interfaces.eth0.ipv4.addresses = [
      { address = serverIP; prefixLength = 24; }
    ];
    wireless.enable                = false;
  };

  nix.maxJobs = 2;

  powerManagement.cpuFreqGovernor = "ondemand";

  services.mingetty.autologinUser = "jupblb";

  users.users.jupblb.extraGroups = [ "docker" ];

  virtualisation.docker.enable = true;
}
