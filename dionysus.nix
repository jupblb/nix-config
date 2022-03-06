{ config, lib, pkgs, ... }:

{
  boot = {
    initrd.availableKernelModules    = [
      "ahci" "nvme" "sd_mod" "usb_storage" "usbhid" "xhci_pci"
    ];
    kernel.sysctl                    = {
      "fs.inotify.max_user_watches" = "204800";
    };
    kernelModules                    = [ "kvm-amd" ];
    loader.efi.canTouchEfiVariables  = true;
    loader.systemd-boot.enable       = true;
    supportedFilesystems             = [ "zfs" ];
    zfs.requestEncryptionCredentials = false;
  };

  environment = {
    interactiveShellInit =
      "echo \"Syncthing is $(systemctl is-active syncthing)\"";
    systemPackages       = with pkgs; [ python3Packages.subliminal ];
  };

  fileSystems = {
    "/"              = {
      device = "/dev/disk/by-label/nixos";
      fsType = "xfs";
    };
    "/backup"        = {
      device  = "backup";
      fsType  = "zfs";
      options = [ "noauto" ];
    };
    "/boot"          = {
      device = "/dev/disk/by-uuid/E668-E8D2";
      fsType = "vfat";
    };
    "/data"          = {
      device = "/dev/disk/by-label/data";
      fsType = "ext4";
    };
    "/nfs/downloads" = {
      device  = "/data/downloads";
      fsType  = "none";
      options = [ "bind" ];
    };
    "/nfs/movies"    = {
      device  = "/data/movies";
      fsType  = "none";
      options = [ "bind" ];
    };
    "/nfs/shows"     = {
      device  = "/data/shows";
      fsType  = "none";
      options = [ "bind" ];
    };
  };

  hardware.cpu.amd.updateMicrocode = true;

  home-manager.users.jupblb = {
    programs = {
      firefox.enable   = lib.mkForce false;
      fish.functions   = {
        zfs-backup-unlock =
          builtins.readFile ./config/script/zfs-backup-unlock.fish;
      };
      mercurial.enable = lib.mkForce false;
    };
  };

  imports = [ ./common/nixos.nix ];

  networking = {
    defaultGateway           = "192.168.1.1";
    domain                   = "kielbowi.cz";
    firewall.allowedTCPPorts = [
      53 67 68 80 111 443 2049 2267 4000 4001 4002 8181 22067 22070
    ];
    firewall.allowedUDPPorts = [
      53 67 68 80 111 443 2049 4000 4001 4002 22067 22070
    ];
    interfaces.enp8s0        = {
      ipv4.addresses = [ { address = "192.168.1.4"; prefixLength = 24; } ];
      wakeOnLan      = { enable = true; };
    };
    hostId                   = "ce5e3a09";
    hostName                 = "dionysus";
    nameservers              = [ "1.1.1.1" "8.8.8.8" ];
    wireless.enable          = false;
  };

  programs.adb.enable                 = true;
  programs.gnupg.agent.pinentryFlavor = "curses";

  services = {
    adguardhome = {
      enable       = true;
      openFirewall = true;
    };

    caddy = {
      email        = "caddy@kielbowi.cz";
      enable       = true;
      virtualHosts =
        let
          basicauth = ''
            basicauth {
              ${secret.login} ${secret.password}
            }
          '';
          secret    = (import ./config/secret.nix).caddy;
        in {
          "adguard.kielbowi.cz"    = {
            extraConfig   = "reverse_proxy http://localhost:3000";
            serverAliases = [ "www.adguard.kielbowi.cz" ];
          };
          "calibre.kielbowi.cz"    = {
            extraConfig   = "reverse_proxy http://localhost:8083";
            serverAliases = [ "www.calibre.kielbowi.cz" ];
          };
          "dionysus.kielbowi.cz"     = {
            extraConfig   = "respond \"Hello, world!\"";
            serverAliases = [ "www.dionysus.kielbowi.cz" ];
          };
          "jellyfin.kielbowi.cz"     = {
            extraConfig   = "reverse_proxy http://localhost:8096";
            serverAliases = [ "www.jellyfin.kielbowi.cz" ];
          };
          "notes.kielbowi.cz"        = {
            extraConfig   = basicauth + ''
              file_server browse {
                root /srv/emanote
              }
            '';
            serverAliases = [ "www.notes.kielbowi.cz" ];
          };
          "paperless.kielbowi.cz"    = {
            extraConfig   = "reverse_proxy http://localhost:28981";
            serverAliases = [ "www.paperless.kielbowi.cz" ];
          };
          "plex.kielbowi.cz"         = {
            extraConfig   = "reverse_proxy http://localhost:32400";
            serverAliases = [ "www.plex.kielbowi.cz" ];
          };
          "shiori.kielbowi.cz"       = {
            extraConfig   = "reverse_proxy http://localhost:8080";
            serverAliases = [ "www.shiori.kielbowi.cz" ];
          };
          "swps.kielbowi.cz"         = {
            extraConfig   = ''
              file_server browse {
                root /srv/emanote-swps
              }
            '';
            serverAliases = [ "www.swps.kielbowi.cz" ];
          };
          "syncthing.kielbowi.cz"    = {
            extraConfig   = basicauth + ''
              reverse_proxy http://localhost:8384 {
                header_up Host localhost
                header_up X-Forwarded-Host syncthing.kielbowi.cz
              }
            '';
            serverAliases = [ "www.syncthing.kielbowi.cz" ];
          };
          "transmission.kielbowi.cz" = {
            extraConfig = basicauth + "reverse_proxy http://127.0.0.1:9091";
          };
        };
    };

    calibre-web = {
      enable  = true;
      group   = "users";
      options = {
        calibreLibrary       = "/backup/calibre";
        enableBookConversion = true;
        enableBookUploading  = true;
      };
    };

    jellyfin = {
      enable = true;
      group  = "users";
    };

    nfs.server = {
      enable     = true;
      exports    = ''
        /nfs *(rw,fsid=0,no_subtree_check)
        /nfs/downloads *(rw,nohide,insecure,no_subtree_check)
        /nfs/movies *(rw,nohide,insecure,no_subtree_check)
        /nfs/shows *(rw,nohide,insecure,no_subtree_check)
      '';
      lockdPort  = 4001;
      mountdPort = 4002;
      statdPort  = 4000;
    };

    paperless-ng = {
      enable      = true;
      extraConfig = {
        PAPERLESS_ALLOWED_HOSTS =
          "paperless.kielbowi.cz,www.paperless.kielbowi.cz";
        PAPERLESS_OCR_LANGUAGE  = "pol+eng";
      };
      mediaDir    = "/backup/paperless";
    };

    plex = {
      enable       = true;
      group        = "users";
      openFirewall = true;
    };

    restic.backups = {
      syncthing-gcs      = {
        environmentFile = toString(
          pkgs.writeText "restic-gcs-env" ''
            GOOGLE_PROJECT_ID=restic-backup-342620
            GOOGLE_APPLICATION_CREDENTIALS=${./config/restic/restic-gcs.json}
          ''
        );
        extraBackupArgs =
          [ "--exclude=./**/.stversions" "--tag syncthing-gcs" ];
        initialize      = true;
        passwordFile    = toString ./config/restic/encryption.txt;
        paths           = [ "/backup" ];
        pruneOpts       = [ "--keep-daily 7" "--keep-weekly 4" ];
        repository      = "gs:dionysus-backup:/";
      };
      syncthing-local    = {
        extraBackupArgs =
          [ "--exclude=./**/.stversions" "--tag syncthing-local" ];
        initialize      = true;
        passwordFile    = toString ./config/restic/encryption.txt;
        paths           = [ "/backup" ];
        pruneOpts       = [ "--keep-daily 1" ];
        repository      = "/data/backup";
      };
      syncthing-poseidon = {
        extraBackupArgs =
          [ "--exclude=./**/.stversions" "--tag syncthing-poseidon" ];
        extraOptions    = [
          "sftp.command='ssh restic@poseidon.kielbowi.cz -i ${toString ./config/ssh/restic/id_ed25519} -s sftp'"
        ];
        initialize      = true;
        passwordFile    = toString ./config/restic/encryption.txt;
        paths           = [ "/backup" ];
        pruneOpts       = [ "--keep-daily 7" "--keep-weekly 4" ];
        repository      =
          "sftp:restic@poseidon.kielbowi.cz:/data/restic/syncthing";
      };
    };

    rss2email = {
      config = {
        "DATE-HEADER" = 1;
        "DIGEST"      = 1;
        "FROM"        = "mailgun@kielbowi.cz";
        "HTML-MAIL"   = 1;
      };
      enable = true;
      feeds  = {
        "bartosz-ciechanowski" = { url = "https://ciechanow.ski/atom.xml"; };
        "console-interviews"   = {
          url = "https://console.dev/interviews/rss.xml";
        };
        "console-tools"        = { url = "https://console.dev/tools/rss.xml"; };
        "drew-devault"         = { url = "https://drewdevault.com/feed.xml"; };
        "jonathan-turner"      = { url = "https://www.jntrnr.com/atom.xml"; };
        "kubernetes"           = { url = "https://kubernetes.io/feed.xml"; };
        "nick-case"            = { url = "http://blog.ncase.me/rss/"; };
        "the-morning-paper"    = { url = "http://blog.acolyer.org/feed/"; };
        "xkcd"                 = { url = "http://xkcd.com/rss.xml"; };
      };
      to     = "rss@kielbowi.cz";
    };

    shellhub-agent = {
      enable   = true;
      tenantId = "c4278ad7-67c3-4c7f-bfe4-b9c0ea011a21";
    };

    shiori.enable = true;

    smartd = {
      autodetect    = false;
      devices       = [
        { device = "/dev/disk/by-id/ata-Lexar_480GB_SSD_K46106J005201"; }
        { device = "/dev/disk/by-id/ata-Lexar_480GB_SSD_K46106J005198"; }
        { device = "/dev/disk/by-id/ata-ST8000VN0022-2EL112_ZA1DT3QD"; }
        { device = "/dev/nvme0n1"; }
      ];
      enable        = true;
      extraOptions  = [ "--interval=7200" "-A /var/log/smartd/" ];
      notifications = {
        mail.enable    = true;
        mail.recipient = "dionysus@kielbowi.cz";
        wall.enable    = false;
      };
    };

    ssmtp = let cfg = (import ./config/secret.nix).mailgun; in {
      authPassFile = toString(pkgs.writeText "mailgun-password" cfg.password);
      authUser     = cfg.login;
      domain       = "kielbowi.cz";
      enable       = true;
      hostName     = "smtp.eu.mailgun.org:587";
      useSTARTTLS  = true;
      useTLS       = true;
    };

    syncthing = {
      cert        = toString ./config/syncthing/dionysus/cert.pem;
      folders     =
        let simpleVersioning = {
          params = {
            cleanInterval = "3600";
            maxAge        = toString(3600 * 24 * 30);
          };
          type   = "staggered";
        };
        in {
          "calibre"         = {
            path = "/backup/calibre";
          };
          "domci/Documents" = {
            path       = "/backup/domci/Documents";
            versioning = simpleVersioning;
          };
          "domci/Downloads" = {
            path = "/backup/domci/Downloads";
          };
          "domci/Pictures" = {
            path       = "/backup/domci/Pictures";
            versioning = simpleVersioning;
          };
          "domci/Videos" = {
            path       = "/backup/domci/Videos";
            versioning = simpleVersioning;
          };
          "jupblb/Documents" = {
            path       = "/backup/jupblb/Documents";
            versioning = simpleVersioning;
          };
          "jupblb/Pictures" = {
            path       = "/backup/jupblb/Pictures";
            versioning = simpleVersioning;
          };
          "paperless"       = {
            path = "/backup/paperless";
          };
        };
      key         = toString ./config/syncthing/dionysus/key.pem;
      relay       = {
        enable        = true;
        listenAddress = "0.0.0.0";
        pools         = [ "" ];
      };
    };

    transmission = {
      enable       = true;
      group        = "users";
      openFirewall = true;
      settings     = {
        download-dir        = "/data/downloads";
        incomplete-dir      = "/data/downloads/.incomplete";
        ratio-limit         = 0;
        ratio-limit-enabled = true;
        rpc-host-whitelist  = "transmission.kielbowi.cz";
      };
    };

    zfs.autoScrub = {
      enable   = true;
      interval = "monthly";
    };
  };

  system.stateVersion = "20.09";

  systemd.services = {
    calibre-web         = { wantedBy = lib.mkForce []; };
    emanote             = {
      after         = [ "network.target" ];
      description   = "Emanote";
      path          = with pkgs; [ emanote findutils gnused ];
      script        = builtins.readFile ./config/script/emanote.sh;
      serviceConfig = { Type = "oneshot"; User = "root"; };
      startAt       = "*:0/15";
    };
    ip-updater          = {
      after         = [ "network.target" ];
      description   = "Public IP updater";
      environment   = (import ./config/secret.nix).ovh;
      path          = with pkgs; [ curl gawk ];
      script        = builtins.readFile ./config/script/ip-updater.sh;
      serviceConfig = {
        ProtectSystem = "full";
        Type          = "oneshot";
        User          = "jupblb";
      };
      startAt       = "*:0/5";
    };
    paperless-ng-server = { wantedBy = lib.mkForce []; };
    syncthing           = { wantedBy = lib.mkForce []; };
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  users.users = {
    jupblb.extraGroups = [ "adbusers" ];
    paperless.group    = lib.mkForce "users";
  };
}
