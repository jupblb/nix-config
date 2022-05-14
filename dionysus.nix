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
    imports = [
      ./home-manager/fish
      ./home-manager/lf.nix
      ./home-manager/neovim
      ./home-manager/starship.nix
      ./home-manager/zoxide.nix
    ];

    programs = {
      fish.functions   = {
        zfs-backup-unlock =
          builtins.readFile ./config/script/zfs-backup-unlock.fish;
      };
    };
  };

  imports = [ ./nixos ./nixos/apc.nix ./nixos/syncthing.nix ];

  networking = {
    defaultGateway           = "192.168.1.1";
    domain                   = "kielbowi.cz";
    firewall.allowedTCPPorts = [
      80 111 443 2049 2267 3012 4000 4001 4002 8181 22067 22070
    ];
    firewall.allowedUDPPorts = [
      80 111 443 2049 3012 4000 4001 4002 22067 22070
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

  programs = {
    adb.enable                 = true;
    gnupg.agent.pinentryFlavor = "curses";
  };

  services = {
    acpid.enable = true;

    apcupsd = {
      configText = "TIMEOUT 30";
      enable     = true;
      hooks      = {
        doshutdown = builtins.readFile ./config/script/dionysus-shutdown.sh;
      };
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
          "calibre.kielbowi.cz"    = {
            extraConfig = "reverse_proxy http://localhost:8083";
          };
          "dionysus.kielbowi.cz"     = {
            extraConfig = "respond \"Hello, world!\"";
          };
          "files.kielbowi.cz"        = {
            extraConfig = basicauth + ''
              file_server browse {
                root /backup/jupblb/
              }
            '';
          };
          "go.kielbowi.cz"           = {
            extraConfig = "reverse_proxy http://localhost:4567";
          };
          "jellyfin.kielbowi.cz"     = {
            extraConfig   = "reverse_proxy http://localhost:8096";
            serverAliases = [ "www.jellyfin.kielbowi.cz" ];
          };
          "notes.kielbowi.cz"        = {
            extraConfig = basicauth + ''
              file_server browse {
                root /srv/emanote
              }
            '';
          };
          "paperless.kielbowi.cz"    = {
            extraConfig = "reverse_proxy http://localhost:28981";
          };
          "photos.kielbowi.cz"       = {
            extraConfig   = "reverse_proxy http://localhost:8012";
            serverAliases = [ "www.photos.kielbowi.cz" ];
          };
          "plex.kielbowi.cz"         = {
            extraConfig   = "reverse_proxy http://localhost:32400";
            serverAliases = [ "www.plex.kielbowi.cz" ];
          };
          "shiori.kielbowi.cz"       = {
            extraConfig = "reverse_proxy http://localhost:8080";
          };
          "swps.kielbowi.cz"         = {
            extraConfig = ''
              file_server browse {
                root /srv/emanote-swps
              }
            '';
          };
          "syncthing.kielbowi.cz"    = {
            extraConfig = basicauth + ''
              reverse_proxy http://localhost:8384 {
                header_up Host localhost
                header_up X-Forwarded-Host syncthing.kielbowi.cz
              }
            '';
          };
          "transmission.kielbowi.cz" = {
            extraConfig = basicauth + "reverse_proxy http://127.0.0.1:9091";
          };
          "vaultwarden.kielbowi.cz" = {
            extraConfig = ''
              encode gzip

              header / {
                # Enable HTTP Strict Transport Security (HSTS)
                Strict-Transport-Security "max-age=31536000;"
                # Enable cross-site filter (XSS) and tell browser to block detected attacks
                X-XSS-Protection "1; mode=block"
                # Disallow the site to be rendered within a frame (clickjacking protection)
                X-Frame-Options "DENY"
                # Prevent search engines from indexing (optional)
                X-Robots-Tag "none"
                # Server name removing
                -Server
              }

              # The negotiation endpoint is also proxied to Rocket
              reverse_proxy /notifications/hub/negotiate http://localhost:8222

              # Notifications redirected to the websockets server
              reverse_proxy /notifications/hub http://localhost:3012

              # Proxy the Root directory to Rocket
              reverse_proxy http://localhost:8222 {
                   # Send the true remote IP to Rocket, so that vaultwarden can put this in the
                   # log, so that fail2ban can ban the correct IP.
                   header_up X-Real-IP {remote_host}
              }
            '';
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
        PAPERLESS_ALLOWED_HOSTS = "paperless.kielbowi.cz";
        PAPERLESS_OCR_LANGUAGE  = "pol+eng";
        PAPERLESS_DBHOST        = "localhost";
      };
      mediaDir    = "/backup/paperless";
    };

    postgresql = {
      authentication  = ''
        # TYPE  DATABASE USER CIDR-ADDRESS METHOD
          local all      all               trust
          host  all      all  samehost     trust
      '';
      enable          = true;
      ensureDatabases = [ "paperless" "photoview" "vaultwarden" ];
      ensureUsers     = [ {
        name              = "paperless";
        ensurePermissions = { "DATABASE paperless" = "ALL PRIVILEGES"; };
      } {
        name              = "photoview";
        ensurePermissions = { "DATABASE photoview" = "ALL PRIVILEGES"; };
      } {
        name              = "vaultwarden";
        ensurePermissions = { "DATABASE vaultwarden" = "ALL PRIVILEGES"; };
      } ];
      package         = pkgs.postgresql_14;
    };

    postgresqlBackup = {
      databases = config.services.postgresql.ensureDatabases;
      enable    = true;
      location  = "/backup/postgresql";
    };

    plex = {
      enable       = true;
      group        = "users";
      openFirewall = true;
    };

    redis.enable = true;

    restic.backups = {
      gcs      = {
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
        pruneOpts       = [ "--keep-weekly 4" "--keep-monthly 3" ];
        repository      = "gs:dionysus-backup:/";
        timerConfig     = { OnCalendar = "weekly"; };
      };
      local    = {
        extraBackupArgs =
          [ "--exclude=./**/.stversions" "--tag syncthing-local" ];
        initialize      = true;
        passwordFile    = toString ./config/restic/encryption.txt;
        paths           = [ "/backup" ];
        pruneOpts       = [ "--keep-daily 14" ];
        repository      = "/data/backup";
      };
      poseidon = {
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
          "domci/Documents"  = {
            enable     = true;
            path       = "/backup/domci/Documents";
            versioning = simpleVersioning;
          };
          "domci/Downloads"  = {
            enable = true;
            path   = "/backup/domci/Downloads";
          };
          "domci/Pictures"   = {
            enable     = true;
            path       = "/backup/domci/Pictures";
            versioning = simpleVersioning;
          };
          "domci/Videos"     = {
            enable     = true;
            path       = "/backup/domci/Videos";
            versioning = simpleVersioning;
          };
          "jupblb/Documents" = {
            enable     = true;
            path       = "/backup/jupblb/Documents";
            versioning = simpleVersioning;
          };
          "jupblb/Pictures"  = {
            enable     = true;
            path       = "/backup/jupblb/Pictures";
            versioning = simpleVersioning;
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

    vaultwarden = {
      config    = let smtpCfg = (import ./config/secret.nix).mailgun; in {
        databaseUrl      = "postgresql://vaultwarden@localhost/vaultwarden";
        domain           = "https://vaultwarden.kielbowi.cz";
        rocketPort       = 8222;
        signupsAllowed   = false;
        signupsVerify    = true;
        smtpFrom         = "mailgun@kielbowi.cz";
        smtpHost         = "smtp.eu.mailgun.org";
        smtpPassword     = smtpCfg.password;
        smtpUsername     = smtpCfg.login;
        websocketEnables = true;
      };
      dbBackend = "postgresql";
      enable    = true;
    };
  };

  system.stateVersion = "20.09";

  systemd.services = {
    calibre-web           = { wantedBy = lib.mkForce []; };
    emanote               = {
      after         = [ "network.target" ];
      description   = "Emanote";
      path          = with pkgs; [ emanote findutils gnused ];
      script        = builtins.readFile ./config/script/emanote.sh;
      serviceConfig = { Type = "oneshot"; User = "root"; };
      startAt       = "*:0/15";
    };
    ip-updater            = {
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
    paperless-ng-server   = { wantedBy = lib.mkForce []; };
    podman-photoview      = { wantedBy = lib.mkForce []; };
    podman-simply-shorten = { wantedBy = lib.mkForce []; };
    syncthing             = { wantedBy = lib.mkForce []; };
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  users.users = {
    jupblb.extraGroups = [ "adbusers" "podman" ];
    paperless.group    = lib.mkForce "users";
  };

  virtualisation = {
    oci-containers = {
      backend    = "podman";
      containers = {
        photoview      = {
          environment  = {
            MAPBOX_TOKEN                       =
              (import ./config/secret.nix).mapbox;
            PHOTOVIEW_DATABASE_DRIVER          = "postgres";
            PHOTOVIEW_DISABLE_FACE_RECOGNITION = "1";
            PHOTOVIEW_LISTEN_PORT              = "8012";
            PHOTOVIEW_POSTGRES_URL             =
              "postgresql://photoview@localhost/photoview";
          };
          extraOptions = [ "--network=host" ];
          image        = "viktorstrate/photoview:2";
          volumes      = [ "/backup/jupblb/Pictures/album:/photos-jupblb:ro" ];
        };
        simply-shorten = {
          environment =
            let pass = (import ./config/secret.nix).simply-shorten;
            in {
              inherit (pass) username password;
              db_url = "/urls.sqlite";
            };
          image       = "draganczukp/simply-shorten";
          ports       = [ "4567:4567" ];
          volumes     = [ "/backup/simply-shorten.sqlite:/urls.sqlite" ];
        };
      };
    };
    podman         = {
      dockerCompat  = true;
      enable        = true;
      extraPackages = with pkgs; [ zfs ];
    };
  };
}
