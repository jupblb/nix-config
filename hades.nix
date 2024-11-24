{ config, lib, pkgs, ... }: {
  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
      luks.devices           = {
        "nixos-home".device = "/dev/disk/by-label/nixos-home-enc";
      };
      systemd.enable         = true;
    };

    # https://github.com/NixOS/nixpkgs/issues/305891#issuecomment-2308910128
    kernelModules = [ "kvm-amd" "nvidia_uvm" ];
    kernelParams  = [ "mitigations=off" ];
  };

  environment = {
    systemPackages   = with pkgs; [ gnome-randr gtasks-md obsidian solaar ];
    variables        = { CUDA_CACHE_PATH = "\${XDG_CACHE_HOME}/nv"; };
  };

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos-root";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-uuid/C301-A009";
    "/boot".fsType = "vfat";
    "/home".device = "/dev/mapper/nixos-home";
    "/home".fsType = "xfs";
  };

  fonts.packages = with pkgs; [ iosevka ];

  hardware = {
    cpu      = { amd.updateMicrocode = true; };
    i2c      = { enable = true; };
    keyboard = { uhk.enable = true; };
    graphics = {
      extraPackages   = with pkgs; [ libvdpau-va-gl vaapiVdpau ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };
    nvidia   = {
      nvidiaSettings  = false;
      open            = true;
      modesetting     = { enable = true; };
      powerManagement = { enable = true; };
    };
    xpadneo  = { enable = true; };
  };

  home-manager.users.jupblb = { config, lib, pkgs, ... }: {
    home = { stateVersion = "22.11"; };

    imports = [
      ./home-manager/direnv.nix
      ./home-manager/kitty.nix
    ];

    services.gpg-agent.enable = true;
  };

  imports = [ ./nixos ];

  networking = {
    firewall = { allowedTCPPorts = [ 3000 ]; };
    hostName = "hades";
    useDHCP  = lib.mkForce true;
  };

  nixpkgs.config = { cudaSupport = true; };

  powerManagement.cpuFreqGovernor = "ondemand";

  programs = {
    nix-ld.enable = true; # https://unix.stackexchange.com/a/522823

    steam = {
      enable                    = true;
      extest                    = { enable = true; };
      localNetworkGameTransfers = { openFirewall = true; };
      remotePlay                = { openFirewall = true; };
    };
  };

  security.sudo.extraRules = [ {
    commands = [ {
      command = "/run/current-system/sw/bin/poweroff";
      options = [ "SETENV" "NOPASSWD" ];
    } ];
    users    = [ "jupblb" ];
  } ];

  services = {
    printing.enable = true;

    psd = {
      enable      = true;
      resyncTimer = "30m";
    };

    sunshine = {
      applications = let steam = config.programs.steam.package; in {
        apps = [ {
          detached   = [ "steam-run-url steam://open/bigpicture" ];
          image-path = "${steam}/share/icons/hicolor/256x256/apps/steam.png";
          name       = "Steam Big Picture";
        } ];
      };
      capSysAdmin  = true;
      enable       = true;
      openFirewall = true;
    };

    syncthing = {
      configDir = "/home/jupblb/.config/syncthing";
      dataDir   = "/home/jupblb/.local/share/syncthing";
      cert      = toString ./config/syncthing/hades/cert.pem;
      key       = toString ./config/syncthing/hades/key.pem;
      settings  = {
        folders = {
          "domci/Documents"  = { path = "/ignore"; };
          "domci/Pictures"   = { path = "/ignore"; };
          "domci/Videos"     = { path = "/ignore"; };
          "jupblb/Documents" = {
            enable = true;
            path   = "/home/jupblb/Documents";
          };
          "jupblb/Pictures"  = {
            enable = true;
            path   = "/home/jupblb/Pictures";
          };
          "jupblb/Workspace" = {
            enable = true;
            path   = "/home/jupblb/Workspace";
          };
        };
      };
      user      = "jupblb";
    };

    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0aaa",\
        ATTR{authorized}="0"
    '';

    xserver.videoDrivers = [ "nvidia" ];
  };

  swapDevices = [ { device = "/dev/disk/by-label/nixos-swap"; } ];

  system.stateVersion = "22.11";

  systemd.user.services = {
    steam-run-url-service = rec {
      enable        = true;
      description   = "Listen and starts Steam games by id";
      wantedBy      = [ "graphical-session.target" ];
      partOf        = wantedBy;
      wants         = wantedBy;
      after         = wantedBy;
      serviceConfig = { Restart = "on-failure"; };
      script        = toString(pkgs.writers.writePython3
        "steam-run-url-service" {}
        (builtins.readFile ./config/script/steam-run-url.py));
      path = [ config.programs.steam.package ];
    };
    sunshine = { path = [ pkgs.steam-run-url ]; };
  };

  users.users.jupblb.extraGroups = [ "docker" "input" "lp" ];

  virtualisation.docker = {
    autoPrune    = { enable = true; };
    enable       = true;
    enableOnBoot = true;
  };
}
