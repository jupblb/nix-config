{ config, lib, pkgs, ... }:

{
  boot = {
    initrd.availableKernelModules   = [
      "ahci" "nvme" "sd_mod" "usb_storage" "usbhid" "xhci_pci"
    ];
    kernel.sysctl                   = {
      "fs.inotify.max_user_watches" = "204800";
    };
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable      = true;
    supportedFilesystems            = [ "zfs" ];
  };

  environment.systemPackages = with pkgs; [ wol ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "xfs";
    };
    "/backup" = {
      device  = "backup";
      fsType  = "zfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/E668-E8D2";
      fsType = "vfat";
    };
    "/data" = {
      device = "/dev/disk/by-label/data";
      fsType = "ext4";
    };
    "/nfs/downloads" = {
      device  = "/home/jupblb/Downloads";
      fsType  = "none";
      options = [ "bind" ];
    };
    "/nfs/movies" = {
      device  = "/data/movies";
      fsType  = "none";
      options = [ "bind" ];
    };
    "/nfs/pictures" = {
      device  = "/backup/jupblb/Pictures/album";
      fsType  = "none";
      options = [ "bind" ];
    };
    "/nfs/shows" = {
      device  = "/data/shows";
      fsType  = "none";
      options = [ "bind" ];
    };
  };

  hardware.cpu.amd.updateMicrocode = true;

  home-manager.users.jupblb = {
    programs = {
      firefox.enable   = lib.mkForce false;
      mercurial.enable = lib.mkForce false;
      tmux.enable      = lib.mkForce false;
    };
  };

  imports = [ ./common/nixos.nix ];

  networking = {
    defaultGateway                   = "192.168.1.1";
    firewall.allowedTCPPorts         = [
      53 67 80 111 443 2049 4000 4001 4002 22067 22070
    ];
    firewall.allowedUDPPorts         = [
      53 67 80 111 443 2049 4000 4001 4002 22067 22070
    ];
    hostId                           = "ce5e3a09";
    hostName                         = "dionysus";
    interfaces.enp8s0.ipv4.addresses = [
      { address = "192.168.1.4"; prefixLength = 24; }
    ];
    nameservers                      = [ "1.1.1.1" "8.8.8.8" ];
    wireless.enable                  = false;
  };

  programs.gnupg.agent.pinentryFlavor = "curses";

  services = {
    dnsmasq = {
      enable              = true;
      extraConfig         =
        let git = "https://github.com/notracking/hosts-blocklists/raw/master";
        in ''
          ${builtins.readFile ./config/dnsmasq.conf}
          conf-file=${builtins.fetchurl "${git}/dnsmasq/dnsmasq.blacklist.txt"}
        '';
      resolveLocalQueries = false;
      servers             = [ "1.1.1.1" "8.8.8.8" ];
    };

    nginx = {
      enable                 = true;
      virtualHosts.localhost = {
        locations = {
          "/transmission" = {
            proxyPass = "http://127.0.0.1:9091/transmission";
          };
          "/nfs/"         = {
            alias       = "/nfs/";
            extraConfig = "autoindex on;";
          };
          "/syncthing/"   = {
            extraConfig = "proxy_set_header Host localhost;";
            proxyPass   = "http://127.0.0.1:8384/";
          };
        };
      };
    };

    nfs.server = {
      enable     = true;
      exports    = ''
        /nfs *(rw,fsid=0,no_subtree_check)
        /nfs/downloads *(rw,nohide,insecure,no_subtree_check)
        /nfs/movies *(rw,nohide,insecure,no_subtree_check)
        /nfs/pictures *(rw,nohide,insecure,no_subtree_check)
        /nfs/shows *(rw,nohide,insecure,no_subtree_check)
      '';
      lockdPort  = 4001;
      mountdPort = 4002;
      statdPort  = 4000;
    };

    smartd = {
      enable        = true;
      extraOptions  = [ "--interval=7200" "-A /var/log/smartd/" ];
      notifications = {
        mail.enable    = true;
        mail.recipient = "mpkielbowicz@gmail.com";
        test           = true;
      };
    };

    ssmtp = {
      authPassFile = toString ./config/gmail.key;
      authUser     = "mpkielbowicz@gmail.com";
      enable       = true;
      hostName     = "smtp.gmail.com:587";
      useSTARTTLS  = true;
      useTLS       = true;
    };

    syncthing = {
      declarative = {
        cert    = toString ./config/syncthing/dionysus/cert.pem;
        folders =
          let simpleVersioning = {
            params = { keep = "5"; };
            type   = "simple";
          };
          in {
            "jupblb/Documents" = {
              path       = "/backup/jupblb/Documents";
              versioning = simpleVersioning;
            };
            "jupblb/Pictures" = {
              path       = "/backup/jupblb/Pictures";
              versioning = simpleVersioning;
            };
          };
        key     = toString ./config/syncthing/dionysus/key.pem;
      };
      relay       = {
        enable        = true;
        listenAddress = "0.0.0.0";
        pools         = [ "" ];
      };
    };

    transmission = {
      enable       = true;
      group        = "users";
      home         = "/home/jupblb";
      openFirewall = true;
      settings     = { ratio-limit = 0; ratio-limit-enabled = true; };
      user         = "jupblb";
    };
  };

  system.stateVersion = "20.09";

  systemd.services.checkip    = {
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

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];
}

