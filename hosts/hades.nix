{ config, pkgs, ... }: {
  boot = {
    initrd         = {
      kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
      network       = { enable = true; };
    };
    kernelModules  = [ "kvm-amd" ];
    plymouth       = { enable = true; extraConfig = "DeviceScale=2"; };
    tmp            = {
      tmpfsHugeMemoryPages = "always";
      useTmpfs             = true;
    };
  };

  environment = {
    systemPackages   =
      let
        extensions = with pkgs.gnomeExtensions;
          [ compiz-windows-effect hide-top-bar removable-drive-menu ];
        packages   = with pkgs;
          [ gnome-firmware nautilus solaar vcmi vlc wl-clipboard ];
      in extensions ++ packages;
    variables        = { CUDA_CACHE_PATH = "\${XDG_CACHE_HOME}/nv"; };
  };

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos-root";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-uuid/C301-A009";
    "/boot".fsType = "vfat";
    "/home".device = "/dev/disk/by-label/nixos-home";
    "/home".fsType = "xfs";
  };

  fonts.packages = with pkgs; [ iosevka ];

  hardware = {
    bluetooth = { enable = true; };
    cpu       = { amd.updateMicrocode = true; };
    i2c       = { enable = true; };
    keyboard  = { uhk.enable = true; };
    graphics  = { enable32Bit = true; };
    nvidia    = {
      nvidiaSettings  = false;
      open            = true;
      powerManagement = { enable = true; };
    };
    xpadneo   = { enable = true; };
  };

  home-manager.users.jupblb = {
    home = { stateVersion = config.system.stateVersion; };

    imports = [
      (import ../home-manager/amp { inherit pkgs; })
      ../home-manager/kitty.nix
    ];

    programs = {
      chromium = {
        enable = true;
        package = pkgs.google-chrome;
      };

      kitty = { settings.linux_display_server = "wayland"; };

      mangohud = {
        enable   = true;
        settings = {
          cpu_temp = true;
          gpu_temp = true;
          ram      = true;
          vram     = true;
        };
      };
    };
  };

  imports = [ ./default.nix ];

  networking = {
    hostName   = "hades";
    # https://wiki.nixos.org/wiki/Wake_on_LAN
    interfaces = { enp8s0 = { wakeOnLan.enable = true; }; };
    firewall   = { allowedUDPPorts = [ 9 ]; };
  };

  nixpkgs.config = { cudaSupport = true; };

  programs = {
    gamescope = { capSysNice = true; enable = true; };
    nix-ld    = { enable = true; }; # https://unix.stackexchange.com/a/522823
    steam     = {
      enable                    = true;
      extest                    = { enable = true; };
      localNetworkGameTransfers = { openFirewall = true; };
      protontricks              = { enable = true; };
      remotePlay                = { openFirewall = true; };
    };
  };

  security = {
    sudo.extraRules = [ {
      commands = [ {
        command = "/run/current-system/sw/bin/poweroff";
        options = [ "SETENV" "NOPASSWD" ];
      } ];
      users    = [ "jupblb" ];
    } ];
  };

  services = {
    desktopManager = { gnome = { enable = true; }; };
    displayManager = {
      autoLogin = { enable = true; user = "jupblb"; };
      gdm       = { enable = true; };
    };

    gnome = { core-apps.enable = false; };

    pipewire  = {
      enable = true;
      alsa   = { enable = true; support32Bit = true; };
      pulse  = { enable = true; };
    };

    printing = { enable = true; };

    syncthing = {
      configDir = "/home/jupblb/.config/syncthing";
      dataDir   = "/home/jupblb/.local/share/syncthing";
      settings  = {
        folders = {
          "jupblb/Documents" = { enable = true; };
          "jupblb/Pictures"  = { enable = false; };
          "jupblb/Workspace" = { enable = true; };
        };
      };
      user      = "jupblb";
    };

    xserver = { enable = true; videoDrivers = [ "nvidia" ]; };
  };

  swapDevices = [ { device = "/dev/disk/by-label/nixos-swap"; } ];

  system = { stateVersion = "22.11"; };

  users.users.jupblb.extraGroups = [ "input" "lp" "vboxusers" ];

  virtualisation = {
    podman     = {
      dockerCompat = true;
      dockerSocket = { enable = true; };
    };
    virtualbox = {
      host = { enable = true; enableExtensionPack = true; };
    };
  };
}
