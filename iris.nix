{ config, pkgs, ... }:

{
  boot = {
    blacklistedKernelModules          = [ "brcmfmac" ];
    consoleLogLevel                   = 7;
    kernelPackages                    = pkgs.linuxPackages_rpi4;
    loader.grub.enable                = false;
    loader.raspberryPi.enable         = true;
    loader.raspberryPi.firmwareConfig = ''
      disable_overscan=1
      dtparam=audio=on
      gpu_mem=192
    '';
    loader.raspberryPi.version        = 4;
  };

  environment.systemPackages = with pkgs; [ wol ];

  fileSystems = {
    "/".device     = "/dev/disk/by-label/NIXOS_SD";
    "/".fsType     = "ext4";
    "/boot".device = "/dev/disk/by-label/NIXOS_BOOT";
    "/boot".fsType = "vfat";
    "/data".device = "/dev/disk/by-label/data";
    "/data".fsType = "ext4";
  };

  hardware = {
    opengl.setLdLibraryPath  = true;
    opengl.package           = pkgs.mesa_drivers;
  };

  imports = [ ./common/nixos.nix ];

  networking = {
    defaultGateway                 = "192.168.1.1";
    firewall.allowedTCPPorts       = [
      53 67 80 111 443 2049 4000 4001 4002
    ];
    firewall.allowedUDPPorts       = [
      53 67 80 111 443 2049 4000 4001 4002
    ];
    hostName                       = "iris";
    interfaces.eth0.ipv4.addresses = [
      { address = "192.168.1.7"; prefixLength = 24; }
    ];
    nameservers                    = [ "1.1.1.1" "8.8.8.8" ];
    wireless.enable                = false;
  };

  nix.maxJobs = 2;

  services = {
    dnsmasq = {
      enable              = true;
      extraConfig         =
        let url =
          "https://github.com/notracking/hosts-blocklists/raw/master/dnsmasq/dnsmasq.blacklist.txt";
        in ''
          ${builtins.readFile ./config/dnsmasq.conf}
          conf-file=${builtins.fetchurl url}
        '';
      resolveLocalQueries = false;
      servers             = [ "1.1.1.1" "8.8.8.8" ];
    };

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
      enable       = true;
      group        = "users";
      openFirewall = true;
      settings     = {
        download-dir           = "/data/transmission";
        incomplete-dir         = "/data/transmission/.incomplete";
        incomplete-dir-enabled = true;
        ratio-limit            = 0;
        ratio-limit-enabled    = true;
        rpc-host-whitelist     = "iris";
        rpc-whitelist          = "127.0.0.1,192.168.*.*";
      };
    };
  };

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
}

