{ config, lib, pkgs, ... }:

{
  boot = {
    initrd.kernelModules             = [ "amdgpu" ];
    kernel.sysctl                    = {
      "fs.inotify.max_user_watches" = "204800";
    };
    kernelModules                    = [ "kvm-amd" ];
    supportedFilesystems             = [ "zfs" ];
    zfs.requestEncryptionCredentials = false;
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

  hardware.cpu.amd = { updateMicrocode = true; };

  home-manager.users.jupblb = {
    home.stateVersion = "21.11";

    imports = [
      ./home-manager/fish
      ./home-manager/lf
      ./home-manager/neovim
    ];

    programs = {
      fish.functions   = {
        zfs-backup-unlock =
          builtins.readFile ./config/script/zfs-backup-unlock.fish;
      };
    };

    services.dropbox = {
      enable = true;
      path   = "/data";
    };
  };

  imports = [ ./nixos ./nixos/syncthing.nix ];

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
    adb.enable = true;

    gnupg.agent.pinentryFlavor = "curses";

    msmtp = {
      enable           = true;
      accounts.default = let cfg = (import ./config/secret.nix).mailgun; in {
        inherit (cfg) password;
        auth         = true;
        host         = "smtp.eu.mailgun.org";
        port         = 587;
        tls          = true;
        tls_starttls = true;
        user         = cfg.login;
      };
    };
  };

  services = {
    acpid.enable = true;

    bazarr = {
      enable = true;
      group  = "users";
    };

    caddy = {
      email        = "caddy@kielbowi.cz";
      enable       = true;
      virtualHosts = {
        "bazarr.kielbowi.cz"       = {
          extraConfig = "reverse_proxy http://localhost:6767";
        };
        "calibre.kielbowi.cz"      = {
          extraConfig = "reverse_proxy http://localhost:8083";
        };
        "dionysus.kielbowi.cz"     = {
          extraConfig = "respond \"Hello, world!\"";
        };
        "files.kielbowi.cz"        = {
          extraConfig = "reverse_proxy http://localhost:8085";
        };
        "go.kielbowi.cz"           = {
          extraConfig = "reverse_proxy http://localhost:4567";
        };
        "haste.kielbowi.cz"        = {
          extraConfig = "reverse_proxy http://localhost:7777";
        };
        "jackett.kielbowi.cz"      = {
          extraConfig = "reverse_proxy http://localhost:9117";
        };
        "jellyfin.kielbowi.cz"     = {
          extraConfig = "reverse_proxy http://localhost:8096";
        };
        "komga.kielbowi.cz"        = {
          extraConfig = "reverse_proxy http://localhost:6428";
        };
        "lidarr.kielbowi.cz"       = {
          extraConfig = "reverse_proxy http://localhost:8686";
        };
        "paperless.kielbowi.cz"    = {
          extraConfig = "reverse_proxy http://localhost:28981";
        };
        "radarr.kielbowi.cz"       = {
          extraConfig = "reverse_proxy http://localhost:7878";
        };
        "rss.kielbowi.cz"       = {
          extraConfig = "reverse_proxy http://localhost:9283";
        };
        "rstudio.kielbowi.cz"      = {
          extraConfig = "reverse_proxy http://localhost:3939";
        };
        "sonarr.kielbowi.cz"       = {
          extraConfig = "reverse_proxy http://localhost:8989";
        };
        "syncthing.kielbowi.cz"    = {
          extraConfig = ''
            reverse_proxy http://localhost:8384 {
              header_up Host localhost
              header_up X-Forwarded-Host syncthing.kielbowi.cz
            }
          '';
        };
        "transmission.kielbowi.cz" = {
          extraConfig = "reverse_proxy http://127.0.0.1:9091";
        };
        "vaultwarden.kielbowi.cz"  = {
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

    haste-server = {
      enable           = true;
      settings.storage = {
        connectionUrl = "postgres://haste@localhost:5432/haste";
        type          = "postgres";
      };
    };

    jackett.enable = true;

    jellyfin = {
      enable = true;
      group  = "users";
    };

    komga = {
      enable = true;
      group  = "users";
      port   = 6428;
    };

    lidarr = {
      enable = true;
      group  = "users";
    };

    miniflux = {
      adminCredentialsFile = pkgs.writeText "miniflux-credentials"
        (import ./config/secret.nix).miniflux;
      config               = {
        BASE_URL                 = "https://rss.kielbowi.cz/";
        FETCH_YOUTUBE_WATCH_TIME = "1";
        LISTEN_ADDR              = "127.0.0.1:9283";
      };
      enable               = true;
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

    paperless = {
      consumptionDir         = "/data/paperless-inbox";
      consumptionDirIsPublic = true;
      enable                 = true;
      extraConfig            = {
        PAPERLESS_ALLOWED_HOSTS              = "paperless.kielbowi.cz";
        PAPERLESS_CONSUMER_DELETE_DUPLICATES = true;
        PAPERLESS_OCR_LANGUAGE               = "pol+eng";
        PAPERLESS_DBHOST                     = "/run/postgresql";
      };
      mediaDir               = "/backup/paperless";
    };

    postgresql = {
      authentication  = ''
        # TYPE  DATABASE USER CIDR-ADDRESS METHOD
          local all      all               trust
          host  all      all  samehost     trust
      '';
      enable          = true;
      ensureDatabases = [ "haste" "paperless" "vaultwarden" ];
      ensureUsers     = [ {
        name              = "haste";
        ensurePermissions = { "DATABASE haste" = "ALL PRIVILEGES"; };
      } {
        name              = "paperless";
        ensurePermissions = { "DATABASE paperless" = "ALL PRIVILEGES"; };
      } {
        name              = "vaultwarden";
        ensurePermissions = { "DATABASE vaultwarden" = "ALL PRIVILEGES"; };
      } ];
      package         = pkgs.postgresql_15;
    };

    postgresqlBackup = {
      databases = config.services.postgresql.ensureDatabases;
      enable    = true;
      location  = "/backup/postgresql";
    };

    radarr = {
      enable = true;
      group  = "users";
    };

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

    rstudio-server = {
      enable             = true;
      package            = pkgs.rstudioServerWrapper.override {
        packages = with pkgs.rPackages; [
          dbscan e1071 effsize factoextra fpc haven learnr lm_beta lsr mclust
          moments NbClust plyr Rcpp shiny tidyverse
        ];
      };
      rserverExtraConfig = ''
        www-port=3939
      '';
    };

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

    sonarr = {
      enable = true;
      group  = "users";
    };

    syncthing = {
      cert         = toString ./config/syncthing/dionysus/cert.pem;
      extraOptions = {
        gui = (import ./config/secret.nix).syncthing;
      };
      folders      =
        let simpleVersioning = {
          params = {
            cleanInterval = "3600";
            maxAge        = toString(3600 * 24 * 30 * 3); # 3 months
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
          "jupblb/Workspace" = {
            enable = true;
            path   = "/backup/jupblb/Workspace";
          };
        };
      key          = toString ./config/syncthing/dionysus/key.pem;
      relay        = {
        enable        = true;
        listenAddress = "0.0.0.0";
        pools         = [ "" ];
      };
    };

    transmission = {
      enable       = true;
      group        = "users";
      openFirewall = true;
      settings     = (import ./config/secret.nix).transmission // {
        download-dir                = "/data/downloads";
        incomplete-dir              = "/data/downloads/.incomplete";
        ratio-limit                 = 0;
        ratio-limit-enabled         = true;
        rpc-enabled                 = true;
        rpc-authentication-required = true;
        rpc-host-whitelist          = "transmission.kielbowi.cz";
      };
    };

    vaultwarden = {
      config          = let smtpCfg = (import ./config/secret.nix).mailgun; in {
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
      dbBackend       = "postgresql";
      enable          = true;
      environmentFile = toString ./config/vaultwarden.env;
    };

    zfs.autoScrub = {
      enable   = true;
      interval = "monthly";
    };
  };

  system.stateVersion = "20.09";

  systemd.services = {
    calibre-web           = { wantedBy = lib.mkForce []; };
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
    jellyfin              = {
      serviceConfig.PrivateDevices = lib.mkForce false;
    };
    komga                 = { wantedBy = lib.mkForce []; };
    paperless-consumer    = { wantedBy = lib.mkForce []; };
    paperless-inbox       = {
      after         = [ "network.target" ];
      description   = "Sync dropbox scans with paperless";
      script        = builtins.readFile ./config/script/paperless-db-sync.sh;
      serviceConfig = {
        ProtectSystem = "full";
        Type          = "oneshot";
        User          = "jupblb";
      };
      startAt       = "*:0";
    };
    paperless-scheduler   = { wantedBy = lib.mkForce []; };
    paperless-web         = { wantedBy = lib.mkForce []; };
    podman-simply-shorten = { wantedBy = lib.mkForce []; };
    syncthing             = { wantedBy = lib.mkForce []; };
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  users.users = {
    jupblb.extraGroups = [ "adbusers" "docker" "podman" ];
    paperless.group    = lib.mkForce "users";
    rstudio            = {
      description                     = "RStudio user";
      initialPassword                 = "changeme";
      isNormalUser                    = true;
      openssh.authorizedKeys.keyFiles = [ ./config/ssh/jupblb/id_ed25519.pub ];
    };
  };

  virtualisation = {
    docker         = { enable = true; };
    oci-containers = {
      backend    = "podman";
      containers = {
        filebrowser    = {
          image   = "filebrowser/filebrowser";
          ports   = [ "8085:80" ];
          volumes = [
            "/backup/files.db:/database.db"
            "/backup/domci:/srv/domci"
            "/backup/jupblb:/srv/jupblb"
            "/data:/srv/data"
          ];
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
      enable        = true;
      extraPackages = with pkgs; [ zfs ];
    };
  };
}
