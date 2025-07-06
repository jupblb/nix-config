{ lib, pkgs, ... }: {
  boot = {
    initrd.availableKernelModules =
      [ "ahci" "nvme" "sd_mod" "usb_storage" "usbhid" "xhci_pci" ];

    loader = {
      efi          = { canTouchEfiVariables = true; };
      systemd-boot = { enable = true; };
    };
  };

  console = {
    earlySetup = true;
    font       = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    keyMap     = "pl";
  };

  environment = {
    sessionVariables = { NIXPKGS_ALLOW_UNFREE = "1"; };
    shellAliases     = { fhs = "${pkgs.steam-run}/bin/steam-run \$SHELL"; };
    systemPackages   = with pkgs; [ file unzip pciutils usbutils ];
  };

  fonts = { enableDefaultPackages = true; };

  hardware = {
    enableRedistributableFirmware = true;
    graphics                      = { enable = true; };
  };

  home-manager.users.jupblb = {
    home     = {
      file = {
        ".ssh/id_ed25519".source     = "/etc/ssh/ssh_host_ed25519_key";
        ".ssh/id_ed25519.pub".source = "/etc/ssh/ssh_host_ed25519_key.pub";
      };
    };
    imports  = [
      ./home-manager
      ./home-manager/ai.nix
      ./home-manager/direnv.nix
      ./home-manager/fish
      ./home-manager/lf
      ./home-manager/neovim
    ];
  };

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "pl_PL.UTF-8/UTF-8" ];

  imports =
    let
      url = "https://github.com/nix-community/home-manager/archive/${tar}";
      tar = "release-25.05.tar.gz";
    in [ "${fetchTarball url}/nixos" ];

  networking = { nameservers = [ "1.1.1.1" "8.8.8.8" ]; };

  nix.settings.trusted-users = [ "root" "jupblb" ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays           = [ (import ./overlay) ];

  programs = {
    bash   = {
      completion     = { enable = true; };
      enableLsColors = true;
      promptInit     = builtins.readFile ./config/bashrc.bash;
    };
    gnupg  = { agent.enable = true; };
    screen = { enable = true; };
    ssh    = { startAgent = true; };
  };

  security = { rtkit.enable = true; };

  services = {
    fstrim = { enable = true; };

    fwupd = { enable = true; };

    pulseaudio = { enable = false; };

    syncthing = {
      enable           = true;
      group            = "users";
      openDefaultPorts = true;
      settings         = {
        devices = {
          artemis  = {
            autoAcceptFolders = true;
            id                =
              "6SIVI3F-YGGPC5T-KFUH3QG-RVCA5U5-SJ2QFGC-STA6KJ3-ITWXE53-3OA6UQW";
          };
          dionysus = {
            autoAcceptFolders = true;
            id                =
              "AUAEQVM-GLWFEY7-ISXW5C6-5FSTG6O-J4D7FI2-LZC7NVM-7AQP4GT-TUBMYA6";
          };
          hades    = {
            autoAcceptFolders = true;
            id                =
              "XTWE5SD-D7HSMCA-5XSO5HO-B2WHNXM-TNPCG2O-FCHX3GJ-65P6ZGY-SYCPHQQ";
          };
          iphone   = {
            autoAcceptFolders = true;
            id                =
              "VUEOA2A-3CZEBCZ-7KD4HWC-2PQYSVE-NKM4MIC-72N2UWQ-4WZGMDC-6TVHQA3";
          };
        };
        folders = {
          "jupblb/Documents" = {
            devices = [ "artemis" "dionysus" "hades" "iphone" ];
            enable  = lib.mkDefault false;
          };
          "jupblb/Pictures"  = {
            devices = [ "artemis" "dionysus" "hades" "iphone" ];
            enable  = lib.mkDefault false;
          };
          "jupblb/Workspace" = {
            devices     = [ "artemis" "dionysus" "hades" ];
            enable      = lib.mkDefault false;
            ignorePerms = false;
          };
        };
        options = {
          urAccepted           = 1;
          localAnnounceEnabled = true;
        };
      };
    };
  };

  system.activationScripts.bin-bash = lib.stringAfter [ "usrbinenv" ] ''
    ln -sfn ${pkgs.bashInteractive}/bin/bash /bin/bash
  '';

  time.timeZone = "Europe/Warsaw";

  users.users.jupblb = {
    description     = "Michal Kielbowicz";
    extraGroups     = [ "wheel" ];
    initialPassword = "changeme";
    isNormalUser    = true;
    openssh         = {
      authorizedKeys.keyFiles = [ ./secret/id_ed25519.pub ];
    };
    shell           = pkgs.bashInteractive;
  };
}
