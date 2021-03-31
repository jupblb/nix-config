{ config, lib, pkgs, ... }:

{
  boot = {
    loader.timeout       = 3;
    supportedFilesystems = [ "ntfs" "exfat" ];
    tmpOnTmpfs           = true;
  };

  console.keyMap = "pl";

  environment.sessionVariables = {
    LD_LIBRARY_PATH      = "${pkgs.stdenv.cc.cc.lib}/lib/";
    NIXPKGS_ALLOW_UNFREE = "1";
  };
  environment.systemPackages   = with pkgs; [
    file git gitAndTools.git-crypt unzip
  ];

  hardware = {
    enableRedistributableFirmware = true;
    video.hidpi.enable            = true;
  };

  home-manager.users.jupblb = {
    imports = [ ./home.nix ];

    nixpkgs.config.packageOverrides = _:
      let t = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      in (import (fetchTarball t) {});
    nixpkgs.overlays                = [
      (self: super: { fish-foreign-env = pkgs.fishPlugins.foreign-env; })
    ];
  };

  i18n.defaultLocale    = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "pl_PL.UTF-8/UTF-8" ];

  imports =
    let
      url = "https://github.com/nix-community/home-manager/archive/${tar}";
      tar = "release-20.09.tar.gz";
    in [ "${fetchTarball url}/nixos" ];

  networking.useDHCP = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays           = [ (import ./overlay) ];

  programs = {
    bash.enableCompletion = true;
    bash.enableLsColors   = true;
    bash.promptInit       = builtins.readFile ../config/bashrc;
    fish.enable           = true;
    gnupg.agent.enable    = true;
    vim.defaultEditor     = true;
  };

  services = {
    acpid.enable = true;

    apcupsd.enable     = true;
    apcupsd.configText = ''
      UPSCABLE usb
      UPSTYPE usb
      DEVICE
      BATTERYLEVEL 10
      MINUTES 5
    '';

    fstrim.enable = true;

    openssh = {
      openFirewall           = true;
      enable                 = true;
      passwordAuthentication = false;
      permitRootLogin        = "no";
    };

    sshguard.enable = true;

    syncthing = {
      enable              = true;
      declarative = {
        devices = {
          artemis.id   =
            "IZVLNXF-53N6C2N-JZJ3AOH-EUOQOFY-JM4CTK7-36EQ4LI-TQC576X-PTTKZAH";
          dionysus.id  =
            "AUAEQVM-GLWFEY7-ISXW5C6-5FSTG6O-J4D7FI2-LZC7NVM-7AQP4GT-TUBMYA6";
          domci-mac.id =
            "RJGQXK6-PVF3555-5U3Y6MK-ADF2SH3-I7VF5UK-U56PSCR-PZJEAF5-5QFZHQ2";
          hades.id     =
            "XTWE5SD-D7HSMCA-5XSO5HO-B2WHNXM-TNPCG2O-FCHX3GJ-65P6ZGY-SYCPHQQ";
        };
        folders = {
          "domci/Documents".devices  = [ "dionysus" "domci-mac" ];
          "domci/Downloads".devices  = [ "dionysus" "domci-mac" ];
          "domci/Pictures".devices   = [ "dionysus" "domci-mac" ];
          "domci/Videos".devices     = [ "dionysus" "domci-mac" ];
          "jupblb/Documents".devices = [ "artemis" "dionysus" "hades"];
          "jupblb/Pictures".devices  = [ "dionysus" "hades" ];
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
    description                 = "Michal Kielbowicz";
    extraGroups                 = [ "wheel" ];
    initialPassword             = "changeme";
    isNormalUser                = true;
    openssh.authorizedKeys.keys = [
      (builtins.readFile ../config/ssh/id_ed25519.pub)
    ];
    shell                       = pkgs.bashInteractive;
  };
}
