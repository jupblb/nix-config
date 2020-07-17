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

  environment.systemPackages = with pkgs; [ wol ];

  fileSystems."/".device     = "/dev/disk/by-label/NIXOS_SD";
  fileSystems."/".fsType     = "ext4";
  fileSystems."/boot".device = "/dev/disk/by-label/NIXOS_BOOT";
  fileSystems."/boot".fsType = "vfat";

  hardware = {
    deviceTree.base         = pkgs.device-tree_rpi;
    deviceTree.overlays     = [
      "${pkgs.device-tree_rpi.overlays}/vc4-fkms-v3d.dtbo"
    ];
    opengl.setLdLibraryPath = true;
    opengl.package          = pkgs.mesa_drivers;
  };

  imports = [ ./common.nix ];

  networking = {
    defaultGateway                 = "192.168.1.1";
    firewall.allowedTCPPorts       = [ 53 67 80 443 ];
    firewall.allowedUDPPorts       = [ 53 67 80 443 ];
    hostName                       = "iris";
    interfaces.eth0.ipv4.addresses = [
      { address = serverIP; prefixLength = 24; }
    ];
    nameservers                    = [ "1.1.1.1" "8.8.8.8" ];
    wireless.enable                = false;
  };

  nix.maxJobs = 2;

  systemd.services.checkip = {
    after         = [ "network.target" ];
    description   = "Public IP checker";
    script        = with pkgs; ''
      ${curl}/bin/curl ipinfo.io/ip >> ~/ip.txt
      ${gawk}/bin/awk '!seen[$0]++' ~/ip.txt > ~/ip.txt.next
      mv ~/ip.txt.next ~/ip.txt
    '';
    serviceConfig = {
      ProtectSystem = "full";
      Type          = "oneshot";
      User          = "jupblb";
    };
    startAt       = "*:0/15";
  };

  users.users.jupblb.extraGroups = [ "docker" ];

  virtualisation.docker.enable = true;
}
