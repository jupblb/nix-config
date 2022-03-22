{ config, lib, pkgs, ... }:

{
  boot.supportedFilesystems = [ "ntfs" "exfat" ];

  console.keyMap = "pl";

  environment.sessionVariables = {
#   LD_LIBRARY_PATH      = "${pkgs.stdenv.cc.cc.lib}/lib/";
    NIXPKGS_ALLOW_UNFREE = "1";
  };
  environment.systemPackages   = with pkgs; [
    file git gitAndTools.git-crypt kitty.terminfo unzip
  ];

  hardware.enableRedistributableFirmware = true;

  home-manager.users.jupblb = {
    imports = [ ./home.nix ];

    nixpkgs.config.packageOverrides = _:
      let t = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable-small.tar.gz";
      in import (fetchTarball t) {};
    nixpkgs.overlays                = [
      (self: super: { fish-foreign-env = pkgs.fishPlugins.foreign-env; })
    ];

    programs.neovim.extraPackages = with pkgs; [ gcc ];
  };

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "pl_PL.UTF-8/UTF-8" ];

  imports =
    let
      url = "https://github.com/nix-community/home-manager/archive/${tar}";
      tar = "master.tar.gz";
    in [ "${fetchTarball url}/nixos" ];

  networking.useDHCP = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays           = [ (import ./overlay) ];

  programs = {
    bash.enableCompletion = true;
    bash.enableLsColors   = true;
    bash.promptInit       = builtins.readFile ../config/bash/bashrc.bash;
    fish.enable           = true;
    gnupg.agent.enable    = true;
    vim.defaultEditor     = true;
  };

  services = {
    acpid.enable = true;

    apcupsd = {
      configText = ''
        UPSCABLE usb
        UPSTYPE usb
        DEVICE
        BATTERYLEVEL 10
      '';
      enable     = true;
    };

    fstrim.enable = true;

    openssh = {
      extraConfig            = "AcceptEnv BAT_THEME";
      openFirewall           = true;
      enable                 = true;
      passwordAuthentication = false;
      permitRootLogin        = "no";
    };

    sshguard.enable = true;

    syncthing = {
      enable              = true;
      devices             = {
        artemis.id   =
          "IZVLNXF-53N6C2N-JZJ3AOH-EUOQOFY-JM4CTK7-36EQ4LI-TQC576X-PTTKZAH";
        dionysus.id  =
          "AUAEQVM-GLWFEY7-ISXW5C6-5FSTG6O-J4D7FI2-LZC7NVM-7AQP4GT-TUBMYA6";
        domci-mac.id =
          "RJGQXK6-PVF3555-5U3Y6MK-ADF2SH3-I7VF5UK-U56PSCR-PZJEAF5-5QFZHQ2";
        hades.id     =
          "XTWE5SD-D7HSMCA-5XSO5HO-B2WHNXM-TNPCG2O-FCHX3GJ-65P6ZGY-SYCPHQQ";
      };
      folders             = {
        "calibre" = {
          devices = [ "dionysus" ];
          enable  = lib.mkDefault false;
        };
        "domci/Documents" = {
          devices = [ "dionysus" "domci-mac" ];
          enable  = lib.mkDefault false;
        };
        "domci/Downloads" = {
          devices = [ "dionysus" "domci-mac" ];
          enable  = lib.mkDefault false;
        };
        "domci/Pictures" = {
          devices = [ "dionysus" "domci-mac" ];
          enable  = lib.mkDefault false;
        };
        "domci/Videos" = {
          devices = [ "dionysus" "domci-mac" ];
          enable  = lib.mkDefault false;
        };
        "jupblb/Documents" = {
          devices = [ "artemis" "dionysus" "hades" ];
          enable  = lib.mkDefault false;
        };
        "jupblb/Pictures" = {
          devices = [ "artemis" "dionysus" "hades" ];
          enable  = lib.mkDefault false;
        };
        "paperless" = {
          devices = [ "dionysus" ];
          enable  = lib.mkDefault false;
        };
      };
      group               = "users";
      openDefaultPorts    = true;
    };
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
