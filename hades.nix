{ lib, pkgs, ... }: {
  boot = {
    consoleLogLevel = 0;
    initrd          = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
      kernelModules          =
        [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
      luks.devices           = {
        "nixos-home".device = "/dev/disk/by-label/nixos-home-enc";
      };
      systemd                = { enable = true; };
    };
    kernelModules   = [ "kvm-amd" ];
    kernelParams    = [ "quiet" "udev.log_level=3" ];
    plymouth        = { enable = true; extraConfig = "DeviceScale=2"; };
  };

  environment = {
    # sessionVariables = { NIXOS_OZONE_WL = "1"; };
    systemPackages   =
      let
        extensions = with pkgs.gnomeExtensions;
          [ compiz-windows-effect hide-top-bar removable-drive-menu ];
        packages   = with pkgs; [
          google-chrome gnome-firmware gtasks-md mangohud nautilus obsidian
          solaar vcmi vlc wl-clipboard
        ];
      in extensions ++ packages;
    variables        = {
      CHROME_EXECUTABLE = pkgs.lib.meta.getExe pkgs.google-chrome;
      CUDA_CACHE_PATH = "\${XDG_CACHE_HOME}/nv";
    };
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
      powerManagement = { enable = true; };
    };
    xpadneo   = { enable = true; };
  };

  home-manager.users.jupblb = { ... }: {
    home = { stateVersion = "22.11"; };

    imports = [
      ./home-manager/direnv.nix
      ./home-manager/kitty.nix
    ];

    programs = { kitty.settings.linux_display_server = "wayland"; };

    services = {
      gpg-agent = {
        enable          = true;
        pinentryPackage = pkgs.pinentry-gnome3;
      };
    };
  };

  imports = [ ./default.nix ];

  networking = {
    firewall = { allowedTCPPorts = [ 3000 ]; };
    hostName = "hades";
  };

  nixpkgs.config = { cudaSupport = true; };

  programs = {
    gamescope = { capSysNice = true; enable = true; };
    nix-ld    = { enable = true; }; # https://unix.stackexchange.com/a/522823
    steam     = {
      enable                    = true;
      extest                    = { enable = true; };
      gamescopeSession          = {
        args   = [
          "--adaptive-sync" "--hdr-enabled" "--hdr-itm-enable" "--rt" "--steam"
          "--prefer-output" "HDMI-A-1" "--nested-refresh" "120"
          "--output-width" "3840" "--output-height" "2160"
        ];
        enable = true;
        env    = {
          MANGOHUD        = "1";
          MANGOHUD_CONFIG = "cpu_temp,gpu_temp,ram,vram";
        };
      };
      localNetworkGameTransfers = { openFirewall = true; };
      protontricks              = { enable = true; };
      remotePlay                = { openFirewall = true; };
    };
  };

  security = {
    pam.services = {
      # https://wiki.archlinux.org/title/GDM#Passwordless_login
      gdm-password.text = lib.mkBefore ''
        auth sufficient pam_succeed_if.so user ingroup nopasswdlogin
      '';
    };

    sudo.extraRules = [ {
      commands = [ {
        command = "/run/current-system/sw/bin/poweroff";
        options = [ "SETENV" "NOPASSWD" ];
      } ];
      users    = [ "jupblb" ];
    } ];
  };

  services = {
    displayManager = { autoLogin = { enable = true; user = "jupblb"; }; };

    gnome = { core-utilities = { enable = false; }; };

    pipewire  = {
      enable = true;
      alsa   = { enable = true; support32Bit = true; };
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

    xserver = {
      enable         = true;
      desktopManager = { gnome = { enable = true; }; };
      displayManager = { gdm = { autoLogin.delay = 5; enable = true; }; };
      videoDrivers   = [ "nvidia" ];
    };
  };

  swapDevices = [ { device = "/dev/disk/by-label/nixos-swap"; } ];

  system.stateVersion = "22.11";

  systemd.services = {
    # https://github.com/NixOS/nixpkgs/issues/103746
    "getty@tty1".enable  = false;
    "autovt@tty1".enable = false;
  };

  users.users.jupblb.extraGroups = [ "docker" "input" "lp" "nopasswdlogin" ];

  virtualisation.docker = {
    autoPrune    = { enable = true; };
    enable       = true;
    enableOnBoot = true;
  };
}
