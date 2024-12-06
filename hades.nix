{ config, lib, pkgs, ... }: {
  boot = {
    consoleLogLevel = 0;
    initrd          = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
      kernelModules          =
        [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
      luks.devices           = {
        "nixos-home".device = "/dev/disk/by-label/nixos-home-enc";
      };
      systemd.enable         = true;
    };

    kernelModules   = [ "kvm-amd" ];
    kernelParams    = [ "mitigations=off" "quiet" "udev.log_level=3" ];
    plymouth        = { enable = true; extraConfig = "DeviceScale=2"; };
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
    bluetooth = { enable = true; };
    cpu       = { amd.updateMicrocode = true; };
    i2c       = { enable = true; };
    keyboard  = { uhk.enable = true; };
    graphics  = {
      enable32Bit     = true;
      extraPackages   = with pkgs; [ libvdpau-va-gl vaapiVdpau ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };
    nvidia    = {
      nvidiaSettings  = false;
      open            = true;
      modesetting     = { enable = true; };
      powerManagement = { enable = true; };
    };
    xpadneo   = { enable = true; };
  };

  home-manager.users.jupblb = { config, lib, pkgs, ... }: {
    home = { stateVersion = "22.11"; };

    imports = [
      ./home-manager/direnv.nix
      ./home-manager/kitty.nix
    ];

    services.gpg-agent.enable = true;
  };

  imports = [ ./nixos ./nixos/gnome.nix ];

  networking = {
    firewall = { allowedTCPPorts = [ 3000 ]; };
    hostName = "hades";
    useDHCP  = lib.mkForce true;
  };

  nixpkgs.config = { cudaSupport = true; };

  powerManagement.cpuFreqGovernor = "ondemand";

  programs = {
    adb    = { enable = true; };
    nix-ld = { enable = true; }; # https://unix.stackexchange.com/a/522823
    steam  = {
      enable                    = true;
      extest                    = { enable = true; };
      localNetworkGameTransfers = { openFirewall = true; };
      protontricks              = { enable = true; };
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
    pipewire  = {
      enable = true;
      alsa   = {
        enable       = true;
        support32Bit = true;
      };
      pulse  = { enable = true; };
    };

    printing = { enable = true; };

    psd = {
      enable      = true;
      resyncTimer = "30m";
    };

    syncthing = {
      configDir = "/home/jupblb/.config/syncthing";
      dataDir   = "/home/jupblb/.local/share/syncthing";
      cert      = toString ./config/syncthing/hades/cert.pem;
      key       = toString ./config/syncthing/hades/key.pem;
      settings  = {
        folders = {
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

  users.users.jupblb.extraGroups = [ "docker" "input" "lp" ];

  virtualisation.docker = {
    autoPrune    = { enable = true; };
    enable       = true;
    enableOnBoot = true;
  };
}
