{ config, pkgs, ... }:

{
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"
      ];
      luks.devices."nixos-home".device = 
        "/dev/disk/by-label/nixos-home-enc";
    };

    kernelParams = [ "mitigations=off" ];

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable             = true;
        configurationLimit = 5;
      };
    };
  };

  environment.systemPackages = with pkgs;
    [ gnomeExtensions.compiz-windows-effect uhk-agent ];

  fileSystems = {
    "/".device     = "/dev/disk/by-label/nixos-root";
    "/".fsType     = "xfs";
    "/boot".device = "/dev/disk/by-uuid/C301-A009";
    "/boot".fsType = "vfat";
    "/home".device = "/dev/mapper/nixos-home";
    "/home".fsType = "xfs";
  };

  fonts.enableDefaultFonts = true;
  fonts.fonts              = with pkgs; [ pragmata-pro ];

  hardware = {
    bluetooth.enable   = true;
    cpu.intel          = { updateMicrocode = true; };
    keyboard.uhk       = { enable = true; };
    opengl             = {
      driSupport      = true;
      driSupport32Bit = true;
      enable          = true;
      extraPackages   = with pkgs; [ libvdpau-va-gl vaapiVdpau ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };
    nvidia             = {
      package            = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
    };
    pulseaudio         = {
      enable  = true;
      package = pkgs.pulseaudioFull;
    };
    video.hidpi.enable = true;
  };

  home-manager.users.jupblb = {
    home.stateVersion = "22.11";

    imports = [
      ./home-manager/direnv.nix
      ./home-manager/fish
      ./home-manager/go.nix
      ./home-manager/kitty.nix
      ./home-manager/lf
      ./home-manager/neovim
      ./home-manager/neovim/lsp.nix
      ./home-manager/qutebrowser
      ./home-manager/zk
    ];

    programs = {
      kitty.settings = {
        hide_window_decorations = "yes";
        linux_display_server    = "wayland";
      };

      google-chrome = {
        enable  = true;
        package = pkgs.google-chrome.override {
          commandLineArgs = [ "--ozone-platform-hint=auto" ];
        };
      };

      qutebrowser.settings = {
        qt.highdpi             = true;
        window.hide_decoration = true;
      };
    };

    services.gpg-agent = {
      enable         = true;
      pinentryFlavor = "gnome3";
    };
  };

  imports = [
    ./nixos
    ./nixos/gnome.nix
    ./nixos/syncthing.nix
  ];

  networking.hostName = "hades";

  powerManagement.cpuFreqGovernor = "ondemand";

  programs.steam = {
    enable     = true;
    remotePlay = { openFirewall = true; };
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

    printing.enable = true;

    syncthing = {
      configDir = "/home/jupblb/.config/syncthing";
      dataDir   = "/home/jupblb/.local/share/syncthing";
      cert      = toString ./config/syncthing/hades/cert.pem;
      folders   = {
        "jupblb/Documents" = {
          enable = true;
          path   = "/home/jupblb/Documents";
        };
        "jupblb/Pictures"  = {
          enable = true;
          path   = "/home/jupblb/Pictures";
        };
      };
      key       = toString ./config/syncthing/hades/key.pem;
      user      = "jupblb";
    };

    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0aaa",\
        ATTR{authorized}="0"
    '';

    xserver.videoDrivers = [ "nvidia" ];
  };

  sound.enable = true;

  swapDevices = [ { device = "/dev/disk/by-label/nixos-swap"; } ];

  system.stateVersion = "20.03";

  systemd.services = {
    # https://github.com/NixOS/nixpkgs/issues/103746
    "getty@tty1".enable  = false;
    "autovt@tty1".enable = false;
  };

  time.hardwareClockInLocalTime = true;

  users.users.jupblb.extraGroups = [ "input" "lp" ];
}
