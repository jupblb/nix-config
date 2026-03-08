{ inputs, pkgs, ... }: {
  boot = {
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
        extensions = with pkgs.gnomeExtensions; [
          compiz-windows-effect hide-top-bar no-overview
          removable-drive-menu
        ];
        packages   = with pkgs; [
          gamescope-wsi gnome-firmware nautilus solaar vcmi vlc
          wl-clipboard
        ];
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
      gsp               = { enable = true; };
      modesetting       = { enable = true; };
      nvidiaSettings    = false;
      open              = true;
      powerManagement   = { enable = true; };
    };
    xpadneo   = { enable = true; };
  };

  home-manager.users.jupblb = {
    imports = [ ../home-manager/kitty.nix ];

    programs = {
      chromium = {
        enable = true;
        package = pkgs.google-chrome;
      };

      kitty = { settings.linux_display_server = "wayland"; };

      mangohud = {
        enable   = true;
        settings = {
          cpu_temp   = true;
          gpu_temp   = true;
          ram        = true;
          toggle_hud = "F6";
          vram       = true;
        };
      };
    };
  };

  imports = [ ./default.nix inputs.jovian-nixos.nixosModules.default ];

  networking = {
    hostName   = "hades";
    # https://wiki.nixos.org/wiki/Wake_on_LAN
    interfaces = { enp8s0 = { wakeOnLan.enable = true; }; };
    firewall   = { allowedUDPPorts = [ 9 ]; };
  };

  nixpkgs = { config = { cudaSupport = true; }; };

  jovian = {
    steam = {
      autoStart      = true;
      desktopSession = "gnome";
      enable         = true;
      user           = "jupblb";
    };
  };

  programs = {
    gamemode  = { enable = true; };
    nix-ld    = { enable = true; }; # https://unix.stackexchange.com/a/522823
    steam     = {
      enable                    = true;
      extest                    = { enable = true; };
      gamescopeSession          = {
        args = [
          "--output-width" "3840"
          "--output-height" "2160"
          "--nested-refresh" "120"
          "--hdr-enabled"
          "--adaptive-sync"
          "--immediate-flips"
          "--mangoapp"
          "--prefer-output" "HDMI-A-3"
          "--force-grab-cursor"
        ];
      };
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
      sddm = { enable = true; };
    };

    gnome = { core-apps.enable = false; };

    pipewire  = {
      enable = true;
      alsa   = { enable = true; support32Bit = true; };
      pulse  = { enable = true; };
    };

    printing = { enable = true; };

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
