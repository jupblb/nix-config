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

  fonts.enableDefaultPackages = true;

  hardware = {
    enableRedistributableFirmware = true;
    graphics                      = { enable = true; };
    pulseaudio                    = { enable = false; };
  };

  home-manager.users.jupblb = {
    home     = { enableNixpkgsReleaseCheck = false; };
    imports  = [
      ../home-manager
      ../home-manager/fish
      ../home-manager/gpg-and-ssh.nix
      ../home-manager/lf
      ../home-manager/neovim
    ];
    services = { gpg-agent.enable = true; };
  };

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "pl_PL.UTF-8/UTF-8" ];

  imports =
    let
      url = "https://github.com/nix-community/home-manager/archive/${tar}";
      tar = "release-24.11.tar.gz";
    in [ "${fetchTarball url}/nixos" ./syncthing.nix ];

  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    useDHCP     = false;
  };

  nix.settings.trusted-users = [ "root" "jupblb" ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays           = [ (import ../overlay) ];

  programs = {
    bash   = {
      completion     = { enable = true; };
      enableLsColors = true;
      promptInit     = builtins.readFile ../config/bashrc.bash;
    };
    gnupg  = { agent.enable = true; };
    screen = { enable = true; };
    ssh    = { startAgent = true; };
  };

  security = { rtkit.enable = true; };

  services = {
    fstrim    = { enable = true; };
    fwupd     = { enable = true; };
    openssh   = {
      openFirewall = true;
      enable       = true;
      settings     = {
        PasswordAuthentication = false;
        PermitRootLogin        = "no";
      };
    };
    sshguard  = { enable = true; };
    tailscale = { enable = true; };
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
      authorizedKeys.keyFiles = [ ../config/ssh/id_ed25519.pub ];
    };
    shell           = pkgs.bashInteractive;
  };
}
