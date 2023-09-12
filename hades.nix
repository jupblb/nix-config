{ pkgs, ... }:

{
  boot = {
    initrd = {
      kernelModules          = [ "e1000e" "i915" "kvm-intel" ];
      luks.devices           = {
        "nixos-home".device = "/dev/disk/by-label/nixos-home-enc";
      };
      network                = {
        enable = true;
        ssh    = {
          authorizedKeys =
            [ (builtins.readFile ./config/ssh/jupblb/id_ed25519.pub) ];
          enable         = true;
          hostKeys       = [ /boot/ssh-key ];
        };
      };
      systemd = {
        enable   = true;
        extraBin = {
          cryptsetup = "${pkgs.cryptsetup}/bin/cryptsetup";
        };
      };
    };

    kernelParams = [ "mitigations=off" ];
  };

  environment = {
#   sessionVariables = { NIXOS_OZONE_WL = "1"; };
    systemPackages   = with pkgs; [ discord nvidia-offload solaar ];
    variables        = {
      CHROME_EXECUTABLE = pkgs.lib.meta.getExe pkgs.google-chrome-wayland;
      CUDA_CACHE_PATH   = "\${XDG_CACHE_HOME}/nv";
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

  fonts.fonts = with pkgs; [ iosevka ];

  hardware = {
    bluetooth.enable   = true;
    cpu.intel          = { updateMicrocode = true; };
    keyboard.uhk       = { enable = true; };
    opengl             = {
      driSupport      = true;
      driSupport32Bit = true;
      enable          = true;
      extraPackages   = with pkgs; [ libvdpau-va-gl vaapiIntel vaapiVdpau ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };
    nvidia             = {
      nvidiaSettings  = false;
      powerManagement = {
        enable      = true;
        finegrained = true;
      };
      prime           = {
        offload.enable = true;
        intelBusId     = "PCI:0:2:0";
        nvidiaBusId    = "PCI:1:0:0";
      };
    };
    pulseaudio         = { enable = false; };
    xpadneo            = { enable = true; };
  };

  home-manager.users.jupblb = { config, lib, pkgs, ... }: {
    home = {
      activation.steam = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD sed 's/^Exec=/&nvidia-offload /' \
          ${pkgs.steam}/share/applications/steam.desktop \
          > ${config.xdg.dataHome}/applications/steam.desktop
        $DRY_RUN_CMD chmod +x ${config.xdg.dataHome}/applications/steam.desktop
        $DRY_RUN_CMD mkdir -p ${config.xdg.configHome}/autostart
        $DRY_RUN_CMD ln -sfn ${config.xdg.dataHome}/applications/steam.desktop \
          ${config.xdg.configHome}/autostart
      '';
      packages         = with pkgs; [ flutter ];
      stateVersion     = "22.11";
    };

    imports = [
      ./home-manager/direnv.nix
      ./home-manager/fish
      ./home-manager/go.nix
      ./home-manager/kitty.nix
      ./home-manager/lf
      ./home-manager/neovim
      ./home-manager/neovim/lsp.nix
    ];

    programs = {
      kitty.settings.linux_display_server = "wayland";
    };

    services.gpg-agent = {
      enable         = true;
      pinentryFlavor = "gnome3";
    };
  };

  imports = [
    ./nixos
    ./nixos/gnome.nix
    ./nixos/npm.nix
    ./nixos/plymouth.nix
    ./nixos/syncthing.nix
  ];

  networking = {
    firewall       = { allowedTCPPorts = [ 3000 ]; };
    hostName       = "hades";
    interfaces     = {
      eno2 = {
        macAddress       = "00:d8:61:50:ae:85";
        useDHCP          = true;
        wakeOnLan.enable = true;
      };
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  programs = {
    nix-ld.enable = true; # https://unix.stackexchange.com/a/522823

    steam = {
      enable     = true;
      remotePlay = { openFirewall = true; };
    };
  };

  security = {
    rtkit.enable    = true;
    sudo.extraRules = [ {
      commands = [ {
        command = "/run/current-system/sw/bin/poweroff";
        options = [ "SETENV" "NOPASSWD" ];
      } ];
      users    = [ "jupblb" ];
    } ];
  };

  services = {
    apcupsd = {
      configText = ''
        UPSCABLE usb
        UPSTYPE usb
        DEVICE
        BATTERYLEVEL 10
      '';
      enable     = true;
    };

    kmscon.extraConfig = "font-dpi=192";

    pipewire = {
      enable = true;
      alsa   = {
        enable       = true;
        support32Bit = true;
      };
      pulse  = { enable = true; };
    };

    printing.enable = true;

    psd = {
      enable      = true;
      resyncTimer = "30m";
    };

    sshguard.whitelist = [ "192.168.1.0/24" ];

    syncthing = {
      configDir = "/home/jupblb/.config/syncthing";
      dataDir   = "/home/jupblb/.local/share/syncthing";
      cert      = toString ./config/syncthing/hades/cert.pem;
      key       = toString ./config/syncthing/hades/key.pem;
      folders   = {
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

  systemd.services = {
    # https://github.com/NixOS/nixpkgs/issues/103746
    "getty@tty1".enable  = false;
    "autovt@tty1".enable = false;
  };

  users.users.jupblb.extraGroups = [ "docker" "input" "lp" ];

  virtualisation.docker = {
    autoPrune    = { enable = true; };
    enable       = true;
    enableNvidia = true;
    enableOnBoot = true;
  };
}
