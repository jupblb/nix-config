{ config, pkgs, ... }:

{
  boot = {
    consoleLogLevel = 0;

    initrd = {
      availableKernelModules =
        [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];

      luks.devices."nixos-home".device = "/dev/disk/by-label/nixos-home-enc";

      kernelModules = [ "i915" ];

      systemd.enable = true;
    };

    kernelParams = [ "mitigations=off" "quiet" "udev.log_level=3" ];

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable             = true;
        configurationLimit = 10;
      };
    };

    plymouth = {
      enable      = true;
      extraConfig = "DeviceScale=2";
    };
  };

  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";

  environment.systemPackages = with pkgs;
    [ gnomeExtensions.compiz-windows-effect nvidia-offload ];

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
      package         = config.boot.kernelPackages.nvidiaPackages.beta;
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

  home-manager.users.jupblb = { lib, pkgs, ... }: {
    home = {
      activation.steam = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD sed 's/^Exec=/&nvidia-offload /' \
          ${pkgs.steam}/share/applications/steam.desktop \
          > ~/.local/share/applications/steam.desktop
        $DRY_RUN_CMD chmod +x ~/.local/share/applications/steam.desktop
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
      ./home-manager/qutebrowser
      ./home-manager/zk
    ];

    programs = {
      google-chrome = {
        enable  = true;
        package = pkgs.google-chrome.override {
          commandLineArgs = [ "--ozone-platform-hint=auto" ];
        };
      };

      kitty.settings = {
        hide_window_decorations = "yes";
        linux_display_server    = "wayland";
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

  security.rtkit.enable = true;

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

  swapDevices = [ { device = "/dev/disk/by-label/nixos-swap"; } ];

  system.stateVersion = "22.11";

  systemd = {
    services = {
      # https://github.com/NixOS/nixpkgs/issues/103746
      "getty@tty1".enable  = false;
      "autovt@tty1".enable = false;
    };
    shutdown = {
      "nvidia" = pkgs.writeShellScript "nvidia-shutdown" ''
        # https://bbs.archlinux.org/viewtopic.php?pid=2049247#p2049247
        for MODULE in nvidia_drm nvidia_modeset nvidia_uvm nvidia; do
            if lsmod | grep "$MODULE" &> /dev/null ; then
               rmmod $MODULE
            fi
        done
      '';
    };
  };

  time.hardwareClockInLocalTime = true;

  users.users.jupblb.extraGroups = [ "input" "lp" ];
}
