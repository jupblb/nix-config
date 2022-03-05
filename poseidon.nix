{ config, lib, pkgs, ... }:

{
  fileSystems = {
    "/data" = { device = "172.16.129.205:/nas/4851"; fsType = "nfs"; };
  };

  home-manager.users.jupblb = {
    programs = {
      firefox.enable   = lib.mkForce false;
      mercurial.enable = lib.mkForce false;
      ssh.enable       = lib.mkForce false;
    };
  };

  imports =
    let vpsadminos = builtins.fetchurl
      "https://raw.githubusercontent.com/vpsfreecz/vpsadminos/staging/os/lib/nixos-container/vpsadminos.nix";
    in [ ./common/nixos.nix vpsadminos ];

  networking = {
    domain                    = "kielbowi.cz";
    firewall.allowedTCPPorts  = [ 80 443 22000 22067 ];
    firewall.allowedUDPPorts  = [ 80 443 22000 22067 ];
    hostName                  = "poseidon";
  };

  programs.gnupg.agent.pinentryFlavor = "curses";

  services = {
    acpid.enable   = lib.mkForce false;
    apcupsd.enable = lib.mkForce false;
    caddy          = {
      email        = "caddy@kielbowi.cz";
      enable       = true;
      virtualHosts = {
          "blog.kielbowi.cz"     = {
            extraConfig   = ''
              file_server browse {
                root /srv/blog
              }
            '';
            serverAliases = [ "www.blog.kielbowi.cz" ];
          };
          "poseidon.kielbowi.cz" = {
            extraConfig   = "respond \"Hello, world!\"";
            serverAliases = [ "www.poseidon.kielbowi.cz" ];
          };
      };
    };
    fstrim.enable  = lib.mkForce false;
    syncthing      = {
      enable = lib.mkForce false;
      relay  = {
        enable        = true;
        listenAddress = "0.0.0.0";
        pools         = [ "" ];
      };
    };
    shellhub-agent = {
      enable   = true;
      tenantId = "c4278ad7-67c3-4c7f-bfe4-b9c0ea011a21";
    };
  };

  system.stateVersion = "21.11";

  systemd = {
    extraConfig = "DefaultTimeoutStartSec=900s";
    services    = {
      hugo = {
        after         = [ "network.target" ];
        description   = "Hugo blog generator";
        path          = with pkgs; [ git hugo ];
        script        = builtins.readFile ./config/script/hugo.sh;
        serviceConfig = { Type = "oneshot"; User = "root"; };
        startAt       = "*:0/15";
      };
    };
  };

  users = {
    groups.restic = {};
    users.restic  = {
      createHome                      = true;
      description                     = "Account to sync restic";
      group                           = "restic";
      home                            = "/data/restic";
      isSystemUser                    = true;
      openssh.authorizedKeys.keyFiles = [ ./config/ssh/restic/id_ed25519.pub ];
      useDefaultShell                 = true;
    };
  };
}