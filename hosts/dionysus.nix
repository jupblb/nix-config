{ config, lib, pkgs, ... }: {
  age.secrets = {
    authelia_jwt_secret             = {
      file  = ./secret/authelia_jwt_secret.age;
      owner = config.services.authelia.instances.default.user;
    };
    authelia_storage_encryption_key = {
      file  = ./secret/authelia_storage_encryption_key.age;
      owner = config.services.authelia.instances.default.user;
    };
    cloudflared_credentials         = {
      file = ./secret/cloudflared_credentials.age;
    };
    github_runner                   = { file = ./secret/github_runner.age; };
    restic_gcs_credentials          = {
      file = ./secret/restic_gcs_credentials.age;
    };
    restic_password                 = {
      file = ./secret/restic_password.age;
    };
  };

  boot = {
    kernel               =
      { sysctl = { "fs.inotify.max_user_watches" = "409600"; }; };
    kernelModules        = [ "kvm-intel" ];
    supportedFilesystems = [ "zfs" ];
    zfs                  = { requestEncryptionCredentials = false; };
  };

  environment = {
    sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
    systemPackages   = with pkgs; [ wakeonlan ];
  };

  fileSystems = {
    "/"              = {
      device = "/dev/disk/by-label/nixos";
      fsType = "xfs";
    };
    # zpool create -f -o ashift=12 \
    #   -O encryption=on -O keyformat=passphrase -O xattr=sa
    #   -O acltype=posixacl -m legacy backup mirror \
    #   ata-Lexar_480GB_SSD_K46106J005198 ata-Lexar_480GB_SSD_K46106J005201
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

  hardware = {
    cpu.intel = { updateMicrocode = true; };
    graphics  = {
      extraPackages = with pkgs;
        [ intel-compute-runtime intel-media-driver vpl-gpu-rt ];
    };
  };

  home-manager.users.jupblb = {
    home.stateVersion = "21.11";

    programs = {
      fish.functions = {
        zfs-backup-unlock =
          builtins.readFile ./config/zfs-backup-unlock.fish;
      };

      git-credential-oauth = { extraFlags = [ "-device" ]; };

      ssh = { enable = lib.mkForce false; };
    };
  };

  imports = [ ./default.nix ];

  networking = {
    domain   = "kielbowi.cz";
    firewall =
      let caddy = [ 80 443 ];
      in {
        allowedTCPPorts  = caddy;
        allowedUDPPorts  = caddy;
      };
    hostId   = "ce5e3a09";
    hostName = "dionysus";
    useDHCP  = true;
    wireless = { enable = false; };
  };

  programs = {
    gnupg.agent = {
      enable          = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
    ssh         = { startAgent = true; };
  };

  services = {
    acpid.enable = true;

    authelia.instances.default = {
      enable   = true;
      secrets  = {
        jwtSecretFile            = config.age.secrets.authelia_jwt_secret.path;
        storageEncryptionKeyFile =
          config.age.secrets.authelia_storage_encryption_key.path;
      };
      settings = {
        access_control         = {
          default_policy = "one_factor";
          rules          = [ {
            domain   = "linkding.kielbowi.cz";
            policy   = "one_factor"; # Config bug, can't be bypassed at home.
          } {
            domain   = "*.kielbowi.cz";
            networks = [ "192.168.1.0/24" ];
            policy   = "bypass";
          } {
            domain   = "prowlarr.kielbowi.cz";
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
        authentication_backend = {
          file.path              = "/var/lib/authelia-default/authelia.yaml";
          password_reset.disable = true;
        };
        notifier               = {
          filesystem = { filename = "/var/lib/authelia-default/authelia.log"; };
        };
        server                 = { address = "tcp://:9092/"; };
        session                = { domain = "kielbowi.cz"; };
        storage                = {
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
          forward_auth http://127.0.0.1:9092 {
              uri /api/verify?rd=https://auth.kielbowi.cz/
              copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
          }
        '';
        in {
          "auth.kielbowi.cz"         = {
            extraConfig = "reverse_proxy http://127.0.0.1:9092";
          };
          "bazarr.kielbowi.cz"       = {
            extraConfig = auth + "reverse_proxy http://127.0.0.1:6767";
          };
          "files.kielbowi.cz"        = {
            extraConfig = auth + "reverse_proxy http://127.0.0.1:8085";
          };
          "go.kielbowi.cz"           = {
            extraConfig = auth + "reverse_proxy http://127.0.0.1:4567";
          };
          "komga.kielbowi.cz"        = {
            extraConfig = "reverse_proxy http://127.0.0.1:6428";
          };
          "linkding.kielbowi.cz"     = {
            extraConfig = auth + "reverse_proxy http://127.0.0.1:9090";
          };
          "prowlarr.kielbowi.cz"     = {
            extraConfig = auth + "reverse_proxy http://127.0.0.1:9696";
          };
          "radarr.kielbowi.cz"       = {
            extraConfig = auth + "reverse_proxy http://127.0.0.1:7878";
          };
          "sonarr.kielbowi.cz"       = {
            extraConfig = auth + "reverse_proxy http://127.0.0.1:8989";
          };
          "syncthing.kielbowi.cz"    = {
            extraConfig = auth + ''
              reverse_proxy http://127.0.0.1:8384 {
                header_up Host 127.0.0.1
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

    chhoto-url = {
      enable = true;
      settings = {
        port        = 4567;
        public_mode = true;
        site_url    = "https://go.kielbowi.cz";
      };
    };

    cloudflared = {
      enable  = true;
      tunnels = {
        "1aa88ef4-665b-41f7-bb26-81a09be0a462" = {
          credentialsFile =
            config.age.secrets.cloudflared_credentials.path;
          default         = "http_status:404";
          ingress         = {
            "calibre.kielbowi.cz"  = "http://localhost:8083";
            "jellyfin.kielbowi.cz" = "http://localhost:8096";

            "hades.kielbowi.cz"    = "ssh://192.168.1.2:22";
            "dionysus.kielbowi.cz" = "ssh://localhost:22";
          };
        };
      };
    };

    filebrowser = {
      enable   = true;
      group    = "users";
      package  = pkgs.symlinkJoin({
        name        = pkgs.filebrowser.name;
        paths       = with pkgs; [ filebrowser ];
        buildInputs = with pkgs; [ makeWrapper ];
        postBuild   = "wrapProgram $out/bin/filebrowser --add-flags --noauth";
      });
      settings = {
        port   = 8085;
        root   = "/var/lib/filebrowser-root";
      };
    };

    flaresolverr = { enable = true; };

    github-runners =
      let
        repos  = [ "awesome-neovim-sorted" "invoice" "justee" ];
        runner = name: {
          enable    = true;
          ephemeral = true;
          replace   = true;
          url       = "https://github.com/jupblb/${name}";
          tokenFile = config.age.secrets.github_runner.path;
        };
      in lib.genAttrs repos runner;

    iperf3 = {
      enable       = true;
      openFirewall = true;
    };

    jellyfin = {
      enable       = true;
      group        = "users";
      openFirewall = true;
    };

    komga = {
      enable   = true;
      group    = "users";
      settings = { server.port = 6428; };
    };

    lidarr = {
      enable = true;
      group  = "users";
    };

    prowlarr = {
      enable   = true;
      settings = {
        auth   = {
          method   = "External";
          required = "DisabledForLocalAddresses";
        };
      };
    };

    radarr = {
      enable = true;
      group  = "users";
      user   = "sonarr";
    };

    restic.backups = {
      gcs   = {
        environmentFile = toString(
          pkgs.writeText "restic-gcs-env" ''
            GOOGLE_PROJECT_ID=restic-backup-342620
            GOOGLE_APPLICATION_CREDENTIALS=${config.age.secrets.restic_gcs_credentials.path}
          ''
        );
        exclude         = [ "**/.stversions" "jupblb/Workspace" ];
        extraBackupArgs = [ "--tag syncthing-gcs" ];
        initialize      = true;
        passwordFile    = config.age.secrets.restic_password.path;
        paths           = [ "/backup" ];
        pruneOpts       = [ "--keep-weekly 4" "--keep-monthly 3" ];
        repository      = "gs:dionysus-backup:/";
        timerConfig     = { OnCalendar = "weekly"; };
      };
      local = {
        exclude         = [ "**/.stversions" ];
        extraBackupArgs = [ "--tag syncthing-local" ];
        initialize      = true;
        passwordFile    = config.age.secrets.restic_password.path;
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
    };

    sonarr = {
      enable = true;
      group  = "users";
    };

    sshguard = { enable = true; };

    syncthing = {
      settings.folders =
        let simpleVersioning = {
          params = {
            cleanInterval = "3600";
            maxAge        = toString(3600 * 24 * 30 * 3); # 3 months
          };
          type   = "staggered";
        };
        in {
          "jupblb/Documents" = {
            enable     = true;
            path       = lib.mkForce("/backup/jupblb/Documents");
            versioning = simpleVersioning;
          };
          "jupblb/Pictures"  = {
            enable     = true;
            path       = lib.mkForce("/backup/jupblb/Pictures");
            versioning = simpleVersioning;
          };
          "jupblb/Workspace" = {
            enable = true;
            path   = lib.mkForce("/backup/jupblb/Workspace");
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
        umask                = 2;
      };
    };

    xserver.videoDrivers = [ "modesetting" ];

    zfs.autoScrub = {
      enable   = true;
      interval = "monthly";
    };
  };

  system = {
    activationScripts = {
      filebrowser-root = ''
        mkdir -p /var/lib/filebrowser-root
        ln -sfn /backup/jupblb/Pictures /var/lib/filebrowser-root/pictures
        ln -sfn /data/movies /var/lib/filebrowser-root/movies
        ln -sfn /data/shows /var/lib/filebrowser-root/shows
      '';
    };
    stateVersion      = "22.05";
  };

  systemd.services =
    let onBackupMount = {
      unitConfig = {
        RequiresMountsFor         = [ "/backup" ];
        ConditionPathIsMountPoint = "/backup";
        After                     = [ "backup.mount" ];
        PartOf                    = [ "backup.mount" ];
      };
      wantedBy   = lib.mkForce [ "backup.mount" ];
    };
    in {
      calibre-web           = onBackupMount;
      jellyfin              = {
        serviceConfig.PrivateDevices = lib.mkForce false;
      };
      restic-backups-gcs    = onBackupMount;
      restic-backups-local  = onBackupMount;
      stignore              = onBackupMount // {
        description   = "Update jupblb/Workspace stignore";
        path          = with pkgs; [
          bash diffutils inotify-tools
          (python3.withPackages(p: with p; [ gitignore-parser ]))
        ];
        script        = ''
          sh ${./config/stignore.sh}

          inotifywait --format "%f" -e 'modify,moved_to,create,delete' \
            -m -r /backup/jupblb/Workspace |
          while read -r line; do
            if [[ "$line" == ".gitignore" ]]; then
              >&2 echo ".gitignore update"
              sh ${./config/stignore.sh}
            fi
          done
        '';
        serviceConfig = {
          ProtectSystem = "full";
          User          = "syncthing";
          Type          = "simple";
        };
      };
      syncthing             = onBackupMount;
    };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  users.users.jupblb.extraGroups = [ "docker" "podman" ];

  virtualisation = {
    docker         = { enable = true; };
    oci-containers = {
      backend    = "podman";
      containers = {
        linkding       = {
          environment = {
            LD_ENABLE_AUTH_PROXY          = "True";
            LD_AUTH_PROXY_USERNAME_HEADER = "HTTP_REMOTE_USER";
            LD_AUTH_PROXY_LOGOUT_URL      = "authelia.kielbowi.cz/logout";
          };
          image       = "sissbruecker/linkding";
          ports       = [ "9090:9090" ];
          volumes     = [ "/data/linkding:/etc/linkding/data" ];
        };
      };
    };
    podman         = { extraPackages = with pkgs; [ zfs ]; };
  };
}
