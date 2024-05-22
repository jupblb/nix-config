{ lib, pkgs, ... }: {
  boot = {
    enableContainers                 = false;
    initrd.kernelModules             = [ "amdgpu" ];
    kernel.sysctl                    = {
      "fs.inotify.max_user_watches" = "409600";
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
    # zpool create -f -o ashift=12 \
    #   -O encryption=on -O keyformat=passphrase -O xattr=sa
    #   -O acltype=posixacl -m legacy backup mirror \
    #   ata-Lexar_480GB_SSD_K46106J005198 ata-Lexar_480GB_SSD_K46106J005
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
  };

  hardware.cpu.amd = { updateMicrocode = true; };

  home-manager.users.jupblb = {
    home.stateVersion = "21.11";

    programs = {
      fish.functions = {
        zfs-backup-unlock =
          builtins.readFile ./config/script/zfs-backup-unlock.fish;
      };
      git.extraConfig = {
        credential.helper = lib.mkForce [
          "cache --timeout 36000"
          "${pkgs.git-credential-oauth}/bin/git-credential-oauth -device"
        ];
      };
    };

    services.gpg-agent.pinentryFlavor = lib.mkForce "curses";
  };

  imports = [ ./nixos ];

  networking = {
    domain            = "kielbowi.cz";
    firewall          =
      let
        caddy     = [ 80 443 ];
        syncthing = [ 22067 22070  ];
      in {
        checkReversePath = "loose";
        allowedTCPPorts  = caddy ++ syncthing ++ [ 3000 8080 ];
        allowedUDPPorts  = caddy ++ syncthing ++ [ 3000 8080 ];
      };
    interfaces.enp8s0 = {
      useDHCP   = true;
      wakeOnLan = { enable = true; };
    };
    hostId            = "ce5e3a09";
    hostName          = "dionysus";
    wireless          = { enable = false; };
  };

  programs = {
    adb.enable = true;

    gnupg.agent = {
      enable         = true;
      pinentryFlavor = "curses";
    };

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

    steam = { enable = true; };
  };

  services = {
    acpid.enable = true;

    authelia.instances.default = {
      enable   = true;
      secrets  = let secrets = (import ./config/secret.nix).authelia; in {
        jwtSecretFile            = pkgs.writeText "authelia-jwt" secrets.jwt;
        storageEncryptionKeyFile =
          pkgs.writeText "authelia-storage" secrets.storage;
      };
      settings = {
        access_control                = {
          default_policy = "one_factor";
          rules          = [ {
            domain   = "*.kielbowi.cz";
            networks = [ "192.168.1.0/18" ];
            policy   = "bypass";
          } {
            domain    = "files.kielbowi.cz";
            # https://github.com/filebrowser/filebrowser/issues/1827#issuecomment-1047777732
            resources = [
              "^/api/public/dl/*" "/share/*" "/static/js/*" "/static/css/*"
              "/static/img/*" "/static/themes/*" "/static/fonts/*"
            ];
            policy    = "bypass";
          } {
            domain    = "go.kielbowi.cz";
            resources = [ "^/.+" ];
            policy    = "bypass";
          } ];
        };
        authentication_backend        = {
          file.path              = "/var/lib/authelia-default/authelia.yaml";
          password_reset.disable = true;
        };
        notifier                      = {
          smtp = let cfg = (import ./config/secret.nix).mailgun; in {
            host     = "smtp.eu.mailgun.org";
            password = cfg.password;
            port     = 587;
            sender   = "mailgun@kielbowi.cz";
            username = cfg.login;
          };
        };
        server                        = { port = 9092; };
        session                       = { domain = "kielbowi.cz"; };
        storage                       = {
          local.path = "/var/lib/authelia-default/authelia.sqlite";
        };
      };
    };

    bazarr = {
      enable = true;
      group  = "users";
      user   = "sonarr";
    };

    caddy = {
      email        = "caddy@kielbowi.cz";
      enable       = true;
      virtualHosts =
        let auth = ''
          forward_auth http://localhost:9092 {
              uri /api/verify?rd=https://auth.kielbowi.cz/
              copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
          }
        '';
        in {
          "auth.kielbowi.cz"         = {
            extraConfig = "reverse_proxy http://localhost:9092";
          };
          "bazarr.kielbowi.cz"       = {
            extraConfig = auth + "reverse_proxy http://localhost:6767";
          };
          "chat.kielbowi.cz"         = {
            extraConfig = auth + "reverse_proxy http://localhost:8972";
          };
          "files.kielbowi.cz"        = {
            extraConfig = auth + "reverse_proxy http://localhost:8085";
          };
          "go.kielbowi.cz"           = {
            extraConfig = auth + "reverse_proxy http://localhost:4567";
          };
          "jackett.kielbowi.cz"      = {
            extraConfig = auth + "reverse_proxy http://localhost:9117";
          };
          "komga.kielbowi.cz"        = {
            extraConfig = "reverse_proxy http://localhost:6428";
          };
          "linkding.kielbowi.cz"     = {
            extraConfig = auth + "reverse_proxy http://localhost:9090";
          };
          "radarr.kielbowi.cz"       = {
            extraConfig = auth + "reverse_proxy http://localhost:7878";
          };
          "sonarr.kielbowi.cz"       = {
            extraConfig = auth + "reverse_proxy http://localhost:8989";
          };
          "syncthing.kielbowi.cz"    = {
            extraConfig = auth + ''
              reverse_proxy http://localhost:8384 {
                header_up Host localhost
                header_up X-Forwarded-Host syncthing.kielbowi.cz
              }
            '';
          };
          "transmission.kielbowi.cz" = {
            extraConfig = auth + "reverse_proxy http://127.0.0.1:9091";
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

    cloudflared = {
      enable  = true;
      tunnels = {
        "1aa88ef4-665b-41f7-bb26-81a09be0a462" = {
          credentialsFile = builtins.toString
            (pkgs.copyPathToStore ./config/cloudflared.json);
          default         = "http_status:404";
          ingress         = {
            "calibre.kielbowi.cz"  = "http://localhost:8083";
            "jellyfin.kielbowi.cz" = "http://localhost:8096";
            "photos.kielbowi.cz"   = "http://localhost:2342";
            "rss.kielbowi.cz"      = "http://localhost:9283";

            "dionysus.kielbowi.cz" = "ssh://localhost:22";
          };
        };
      };
    };

    # https://github.com/ddclient/ddclient/blob/afa127525380d8c3e19b2046bca6843346b1ab0d/ddclient.conf.in#L186-L194
    ddclient = {
      enable       = true;
      domains      = [ "*.kielbowi.cz" ];
      passwordFile = toString(pkgs.writeText "ddclient"
        ((import ./config/secret.nix).cloudflare));
      protocol     = "cloudflare";
      ssl          = true;
      use          = "web,web=ifconfig.me/ip";
      username     = "token";
      zone         = "kielbowi.cz";
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

    photoprism = {
      enable        = true;
      originalsPath = "/backup/jupblb/Pictures/album";
      settings      = {
        PHOTOPRISM_DETECT_NSFW      = "true";
        PHOTOPRISM_DISABLE_SETTINGS = "true";
        PHOTOPRISM_DISABLE_WEBDAV   = "true";
        PHOTOPRISM_READONLY         = "true";
        PHOTOPRISM_SITE_URL         = "https://photos.kielbowi.cz";
        PHOTOPRISM_UPLOAD_NSFW      = "false";
      } // (import ./config/secret.nix).photoprism;
    };

    postgresql = {
      authentication  = ''
        # TYPE  DATABASE USER CIDR-ADDRESS METHOD
          local all      all               trust
          host  all      all  samehost     trust
      '';
      enable          = true;
      package         = pkgs.postgresql_15;
    };

    postgresqlBackup = {
      backupAll = true;
      enable    = true;
      location  = "/backup/postgresql";
    };

    radarr = {
      enable = true;
      group  = "users";
    };

    restic.backups =
      let passwordFile = pkgs.writeText "restic"
        ((import ./config/secret.nix).restic);
      in {
        gcs   = {
          environmentFile = toString(
            pkgs.writeText "restic-gcs-env" ''
              GOOGLE_PROJECT_ID=restic-backup-342620
              GOOGLE_APPLICATION_CREDENTIALS=${./config/restic-gcs.json}
            ''
          );
          exclude         = [ "**/.stversions" "jupblb/Workspace" ];
          extraBackupArgs = [ "--tag syncthing-gcs" ];
          initialize      = true;
          passwordFile    = toString passwordFile;
          paths           = [ "/backup" ];
          pruneOpts       = [ "--keep-weekly 4" "--keep-monthly 3" ];
          repository      = "gs:dionysus-backup:/";
          timerConfig     = { OnCalendar = "weekly"; };
        };
        local = {
          exclude         = [ "**/.stversions" ];
          extraBackupArgs = [ "--tag syncthing-local" ];
          initialize      = true;
          passwordFile    = toString passwordFile;
          paths           = [ "/backup" ];
          pruneOpts       = [ "--keep-daily 14" ];
          repository      = "/data/backup";
        };
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
      cert     = toString ./config/syncthing/dionysus/cert.pem;
      key      = toString ./config/syncthing/dionysus/key.pem;
      relay    = {
        enable        = true;
        listenAddress = "0.0.0.0";
        pools         = [ "" ];
      };
      settings = {
        folders =
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
      };
    };

    transmission = {
      enable   = true;
      group    = "users";
      package  = pkgs.transmission_4;
      settings = {
        download-dir         = "/data/downloads";
        incomplete-dir       = "/data/downloads/.incomplete";
        ratio-limit          = 0;
        ratio-limit-enabled  = true;
        rpc-host-whitelist   = "transmission.kielbowi.cz";
      };
    };

    xserver.videoDrivers = [ "amdgpu" ];

    zfs.autoScrub = {
      enable   = true;
      interval = "monthly";
    };
  };

  system.stateVersion = "20.09";

  systemd.services = let disableAtBoot = { wantedBy = lib.mkForce []; }; in {
    calibre-web           = disableAtBoot;
    ip-updater            = {
      after         = [ "network.target" ];
      description   = "Public IP updater";
      path          = with pkgs; [ curl gawk ];
      script        = builtins.readFile ./config/script/ip-updater.sh;
      serviceConfig = {
        ProtectSystem = "full";
        User          = "jupblb";
        Type          = "oneshot";
      };
      startAt       = "*:0";
    };
    jellyfin              = {
      serviceConfig.PrivateDevices = lib.mkForce false;
    };
    photoprism            = disableAtBoot;
    podman-filebrowser    = disableAtBoot;
    podman-simply-shorten = disableAtBoot;
    postgresqlBackup      = disableAtBoot;
    restic-backups-gcs    = disableAtBoot;
    restic-backups-local  = disableAtBoot;
    stignore              = disableAtBoot // {
      description   = "Update jupblb/Workspace stignore";
      path          = with pkgs; [
        bash diffutils inotify-tools
        (python3.withPackages(p: with p; [ gitignore-parser ]))
      ];
      script        = ''
        sh ${./config/script/stignore.sh}

        inotifywait --format "%f" -e 'modify,moved_to,create,delete' \
          -m -r /backup/jupblb/Workspace |
        while read line; do
          if [[ "$line" == ".gitignore" ]]; then
            >&2 echo ".gitignore update"
            sh ${./config/script/stignore.sh}
          fi
        done
      '';
      serviceConfig = {
        ProtectSystem = "full";
        User          = "syncthing";
        Type          = "simple";
      };
      wantedBy      = [ "multi-user.target" ];
    };
    syncthing             = disableAtBoot;
    syncthing-init        = disableAtBoot;
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  users.users.jupblb.extraGroups = [ "adbusers" "docker" "podman" ];

  virtualisation = {
    docker         = { enable = true; };
    oci-containers = {
      backend    = "podman";
      containers = {
        filebrowser    = {
          cmd     = [ "--noauth" ];
          image   = "filebrowser/filebrowser";
          ports   = [ "8085:80" ];
          volumes = [
            "/backup/files.db:/database.db"
            "/backup/domci:/srv/domci"
            "/backup/jupblb:/srv/jupblb"
            "/data:/srv/data"
          ];
        };
        linkding       = {
          environment = {
            LD_ENABLE_AUTH_PROXY = "True";
            LD_AUTH_PROXY_USERNAME_HEADER = "HTTP_REMOTE_USER";
            LD_AUTH_PROXY_LOGOUT_URL      = "authelia.kielbowi.cz/logout";
          };
          image       = "sissbruecker/linkding";
          ports       = [ "9090:9090" ];
          volumes     = [ "/data/linkding:/etc/linkding/data" ];
        };
        simply-shorten = {
          environment = {
            db_url                    = "/urls.sqlite";
            INSECURE_DISABLE_PASSWORD = "I_KNOW_ITS_BAD";
          };
          image       = "draganczukp/simply-shorten";
          ports       = [ "4567:4567" ];
          volumes     = [ "/data/simply-shorten.sqlite:/urls.sqlite" ];
        };
      };
    };
    podman         = {
      enable        = true;
      extraPackages = with pkgs; [ zfs ];
    };
  };
}
