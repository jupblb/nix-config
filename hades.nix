{ lib, pkgs, ... }: {
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
    systemPackages   = with pkgs; [ discord obsidian solaar ];
    variables        = { CUDA_CACHE_PATH   = "\${XDG_CACHE_HOME}/nv"; };
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
    cpu      = { intel.updateMicrocode = true; };
    i2c      = { enable = true; };
    keyboard = { uhk.enable = true; };
    opengl   = {
      extraPackages   = with pkgs; [ libvdpau-va-gl vaapiVdpau ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };
    nvidia   = {
      modesetting     = { enable = true; };
      nvidiaSettings  = false;
      # open            = true;
      powerManagement = { enable = true; };
    };
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
    firewall        = { allowedTCPPorts = [ 3000 ]; };
    hostName        = "hades";
    interfaces.eno2 = {
      macAddress       = "00:d8:61:50:ae:85";
      useDHCP          = true;
      wakeOnLan.enable = true;
    };
  };

  # https://github.com/nixified-ai/flake#enable-binary-cache
  nix.settings = {
    trusted-substituters = ["https://ai.cachix.org"];
    trusted-public-keys  =
      ["ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="];
  };

  nixpkgs.config = {
    cudaSupport               = true;
    # https://github.com/NixOS/nixpkgs/issues/273611
    permittedInsecurePackages =
      lib.optional (pkgs.obsidian.version == "1.4.16") "electron-25.9.0";
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
