{ config, pkgs, ... }:

let
  serverIP = "192.168.1.7";
  sway     = pkgs.unstable.sway'.override { withScaling = true; };
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ./common.nix
  ];

  boot.blacklistedKernelModules          = [ "brcmfmac" ];
  boot.consoleLogLevel                   = 7;
  boot.kernelPackages                    = pkgs.linuxPackages_rpi4;
  boot.loader.grub.enable                = false;
  boot.loader.raspberryPi.enable         = true;
  boot.loader.raspberryPi.firmwareConfig = ''
    disable_overscan=1
    dtparam=audio=on
    gpu_mem=256
  '';
  boot.loader.raspberryPi.version        = 4;

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

  environment.systemPackages = [ sway ];

  fileSystems."/".device     = "/dev/disk/by-label/NIXOS_SD";
  fileSystems."/".fsType     = "ext4";
  fileSystems."/boot".device = "/dev/disk/by-label/FIRMWARE";
  fileSystems."/boot".fsType = "vfat";

  hardware.bluetooth.enable        = true;
  hardware.deviceTree.base         = pkgs.device-tree_rpi;
  hardware.deviceTree.overlays     = [ "${pkgs.device-tree_rpi.overlays}/vc4-fkms-v3d.dtbo" ];
  hardware.opengl.setLdLibraryPath = true;
  hardware.opengl.package          = pkgs.mesa_drivers;
  hardware.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];
  hardware.pulseaudio.package      = pkgs.pulseaudioFull;

  networking.defaultGateway                 = "192.168.1.1";
  networking.firewall.allowedTCPPorts       = [ 53 67 80 443 ];
  networking.firewall.allowedUDPPorts       = [ 53 67 80 443 ];
  networking.hostName                       = "iris";
  networking.interfaces.eth0.ipv4.addresses = [ { address = "192.168.1.7"; prefixLength = 24; } ];
  networking.wireless.enable                = false;

  nix.maxJobs = 2;

  powerManagement.cpuFreqGovernor = "ondemand";

  services.blueman.enable         = true;
  services.mingetty.autologinUser = "jupblb";

  users.users.jupblb.extraGroups = [ "docker" ];

  virtualisation.docker.enable = true;
}
