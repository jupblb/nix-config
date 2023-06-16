{ lib, pkgs, ... }:

{
  boot = {
    initrd.availableKernelModules =
      [ "ahci" "nvme" "sd_mod" "usb_storage" "usbhid" "xhci_pci" ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot             = {
        enable             = true;
        configurationLimit = 10;
      };
    };
  };

  console = {
    earlySetup = true;
    font       = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    keyMap     = "pl";
  };

  environment.sessionVariables = { NIXPKGS_ALLOW_UNFREE = "1"; };
  environment.systemPackages   = with pkgs;
    [ file unzip wl-clipboard pciutils usbutils wol ];

  fonts.enableDefaultFonts = true;

  hardware.enableRedistributableFirmware = true;

  home-manager.users.jupblb = {
    imports = [ ../home-manager ];

    nixpkgs.config.packageOverrides = _:
      let t = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      in import (fetchTarball t) {};

    services.gpg-agent.enable = true;
  };

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "pl_PL.UTF-8/UTF-8" ];

  imports =
    let
      url = "https://github.com/nix-community/home-manager/archive/${tar}";
      tar = "master.tar.gz";
    in [ "${fetchTarball url}/nixos" ];

  networking.useDHCP = false;

  nix.settings.trusted-users = [ "root" "jupblb" ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays           = [ (import ../overlay) ];

  programs = {
    adb   = { enable = true; };
    bash  = {
      enableCompletion = true;
      enableLsColors   = true;
      promptInit       = builtins.readFile ../config/bashrc.bash;
    };
    gnupg = { agent.enable = true; };
    ssh   = { startAgent = true; };
    vim   = { defaultEditor = true; };
  };

  services = {
    fstrim.enable = true;

    fwupd.enable = true;

    kmscon = {
      autologinUser = "jupblb";
      # https://github.com/Aetf/kmscon/issues/29
      enable        = false;
      fonts         = [
        { name = "Source Code Pro"; package = pkgs.source-code-pro; }
      ];
      hwRender      = true;
    };

    openssh = {
      openFirewall = true;
      enable       = true;
      settings     = {
        PasswordAuthentication = false;
        PermitRootLogin        = "no";
      };
    };

    sshguard.enable = true;

    tailscale.enable = true;
  };

  system.activationScripts.bin-bash = lib.stringAfter [ "usrbinenv" ] ''
    ln -sfn ${pkgs.bashInteractive}/bin/bash /bin/bash
  '';

  time.timeZone = "Europe/Warsaw";

  users.users.jupblb = {
    description                     = "Michal Kielbowicz";
    extraGroups                     = [ "wheel" ];
    initialPassword                 = "changeme";
    isNormalUser                    = true;
    openssh.authorizedKeys.keyFiles = [ ../config/ssh/jupblb/id_ed25519.pub ];
    shell                           = pkgs.bashInteractive;
  };
}
