{ config, lib, pkgs, ... }:

{
  boot = {
    initrd.availableKernelModules   = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    kernel.sysctl                   = {
      "fs.inotify.max_user_watches" = "204800";
    };
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable      = true;
  };

  environment.systemPackages = with pkgs; [ wol ];

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-uuid/E668-E8D2";
    "/boot".fsType = "vfat";
  };

  imports = [ ./common/nixos.nix ];

  networking = {
    defaultGateway                 = "192.168.1.1";
    firewall.allowedTCPPorts       = [
      53 67 80 111 443 2049 4000 4001 4002 22067 22070
    ];
    firewall.allowedUDPPorts       = [
      53 67 80 111 443 2049 4000 4001 4002 22067 22070
    ];
    hostName                       = "dionysus";
    interfaces.enp8s0.ipv4.addresses = [
      { address = "192.168.1.4"; prefixLength = 24; }
    ];
    nameservers                    = [ "1.1.1.1" "8.8.8.8" ];
    wireless.enable                = false;
  };

  programs.gnupg.agent.pinentryFlavor = "curses";

  services = {
    dnsmasq = {
      enable              = false;
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

    nginx = {
      enable                 = false;
      virtualHosts.localhost = {
        locations = {
          "/files/"           = {
            alias       = "/nfs/";
            extraConfig = "autoindex on;";
          };
          "/syncthing/"    = {
            extraConfig = "proxy_set_header Host localhost;";
            proxyPass   = "http://127.0.0.1:8384/";
          };
          "/transmission" = {
            proxyPass = "http://127.0.0.1:9091/transmission";
          };
        };
      };
    };

    nfs.server = {
      enable     = true;
      exports    = ''
        /nfs *(rw,fsid=0,no_subtree_check)
        /nfs/movies *(rw,nohide,insecure,no_subtree_check)
        /nfs/pictures *(rw,nohide,insecure,no_subtree_check)
        /nfs/shows *(rw,nohide,insecure,no_subtree_check)
        /nfs/transmission *(rw,nohide,insecure,no_subtree_check)
      '';
      lockdPort  = 4001;
      mountdPort = 4002;
      statdPort  = 4000;
    };

    smartd = {
      enable        = true;
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
        cert    = toString ./config/syncthing/iris/cert.pem;
        folders =
          let simpleVersioning = {
            params = { keep = "5"; };
            type   = "simple";
          };
          in {
            "jupblb/Documents" = {
              path       = "/nfs/syncthing/jupblb/Documents";
              versioning = simpleVersioning;
            };
            "jupblb/Pictures" = {
              path       = "/nfs/syncthing/jupblb/Pictures";
              versioning = simpleVersioning;
            };
          };
        key     = toString ./config/syncthing/iris/key.pem;
      };
      enable      = lib.mkForce false;
      relay       = {
        enable        = true;
        listenAddress = "0.0.0.0";
        pools         = [ "" ];
      };
    };

    transmission = {
      enable       = false;
      group        = "users";
      openFirewall = true;
      settings     = {
        download-dir           = "/nfs/transmission";
        incomplete-dir         = "/nfs/transmission/.incomplete";
        incomplete-dir-enabled = true;
        ratio-limit            = 0;
        ratio-limit-enabled    = true;
      };
    };
  };

  system.stateVersion = "20.09";

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

