{ pkgs, ... }: {
  boot = {
    initrd = {
      kernelModules  = [ "e1000e" "i915" "kvm-intel" ];
      luks.devices   = {
        "nixos-home".device = "/dev/disk/by-label/nixos-home-enc";
      };
      systemd.enable = true;
    };

    kernelParams = [ "mitigations=off" ];
  };

  environment = {
#   sessionVariables = { NIXOS_OZONE_WL = "1"; };
    systemPackages   = with pkgs;
      [ discord nvidia-offload protontricks solaar ];
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
    cpu.intel          = { updateMicrocode = true; };
    i2c.enable         = true;
    keyboard.uhk       = { enable = true; };
    opengl             = {
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

    services.gpg-agent.enable = true;
  };

  imports = [ ./nixos ];

  networking = {
    firewall        = { allowedTCPPorts = [ 3000 ]; };
    hostName        = "hades";
    interfaces.eno2 = {
      macAddress       = "00:d8:61:50:ae:85";
      useDHCP          = true;
      wakeOnLan.enable = true;
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

  security.sudo.extraRules = [ {
    commands = [ {
      command = "/run/current-system/sw/bin/poweroff";
      options = [ "SETENV" "NOPASSWD" ];
    } ];
    users    = [ "jupblb" ];
  } ];

  services = {
    kmscon.extraConfig = "font-dpi=192";

    printing.enable = true;

    psd = {
      enable      = true;
      resyncTimer = "30m";
    };

    syncthing = {
      configDir = "/home/jupblb/.config/syncthing";
      dataDir   = "/home/jupblb/.local/share/syncthing";
      cert      = toString ./config/syncthing/hades/cert.pem;
      key       = toString ./config/syncthing/hades/key.pem;
      folders   = {
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
    enableNvidia = true;
    enableOnBoot = true;
  };
}
