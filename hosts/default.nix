{ config, inputs, lib, pkgs, ... }: {
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
    nixpkgs.overlays = [
      (_: _: { amp-cli = inputs.llm-agents.packages.${pkgs.system}.amp; })
    ];

    home     = {
      file         = {
        ".ssh/id_ed25519".source     = "/etc/ssh/ssh_host_ed25519_key";
        ".ssh/id_ed25519.pub".source = "/etc/ssh/ssh_host_ed25519_key.pub";
      };
      stateVersion = config.system.stateVersion;
    };
    imports  = [
      ../home-manager
      ../home-manager/fish
      ../home-manager/lf
      ../home-manager/neovim
    ];
  };

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "pl_PL.UTF-8/UTF-8" ];

  imports = [
    inputs.determinate.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];

  networking = { nameservers = [ "1.1.1.1" "8.8.8.8" ]; };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users         = [ "root" "jupblb" ];
    };
  };

  nixpkgs = { config.allowUnfree = true; };

  programs = {
    bash   = {
      completion     = { enable = true; };
      enableLsColors = true;
    };
    fish   = { enable = true; };
    gnupg  = { agent.enable = true; };
    screen = { enable = true; };
  };

  security = { rtkit.enable = true; };

  services = {
    fstrim = { enable = true; };

    fwupd = { enable = true; };

    openssh = {
      openFirewall = true;
      enable       = true;
      settings     = {
        PasswordAuthentication = true;
        PermitRootLogin        = "no";
      };
    };

    pulseaudio = { enable = false; };
  };

  system.activationScripts.bin-bash = lib.stringAfter [ "usrbinenv" ] ''
    ln -sfn ${pkgs.bashInteractive}/bin/bash /bin/bash
  '';

  time.timeZone = "Europe/Warsaw";

  users.users.jupblb = {
    description     = "Michal Kielbowicz";
    extraGroups     = [ "podman" "wheel" ];
    initialPassword = "changeme";
    isNormalUser    = true;
    openssh         = {
      authorizedKeys.keyFiles = [ ./secret/id_ed25519.pub ];
    };
    shell           = pkgs.fish;
  };

  virtualisation = {
    podman = {
      autoPrune = { enable = true; };
      enable    = true;
    };
  };
}
