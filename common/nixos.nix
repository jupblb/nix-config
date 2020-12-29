{ config, lib, pkgs, ... }:

{
  boot = {
    kernelParams         = [ "mitigations=off" ];
    loader.timeout       = 3;
    supportedFilesystems = [ "ntfs" "exfat" ];
    tmpOnTmpfs           = true;
  };

  console = {
    colors     = [
      "f9f5d7" "cc241d" "98971a" "d79921"
      "458588" "b16286" "689d6a" "7c6f64"
      "928374" "9d0006" "79740e" "b57614"
      "076678" "8f3f71" "427b58" "3c3836"
    ];
    keyMap     = "pl";
  };

  environment.sessionVariables = { NIXPKGS_ALLOW_UNFREE = "1"; };
  environment.systemPackages   = with pkgs; [ file git gitAndTools.git-crypt unzip ];

  hardware = {
    enableRedistributableFirmware = true;
    opengl.enable                 = true;
    pulseaudio.enable             = true;
    video.hidpi.enable            = true;
  };

  i18n.defaultLocale    = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "pl_PL.UTF-8/UTF-8" ];

  networking.useDHCP = false;

  nixpkgs.config.allowUnfree = true;

  programs = {
    bash.enableCompletion = true;
    bash.enableLsColors   = true;
    bash.promptInit       = builtins.readFile ../config/bashrc;
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

    openssh = {
      openFirewall           = true;
      enable                 = true;
      passwordAuthentication = false;
      permitRootLogin        = "no";
      ports                  = [ 22 1993 ];
    };

    printing = {
      drivers = with pkgs; [ samsung-unified-linux-driver_1_00_37 ];
      enable  = true;
    };

    sshguard.enable = true;

    syncthing = {
      enable              = true;
      declarative = {
        devices = {
          artemis.id =
            "XKAGTTE-T22BOZ7-X7Z447S-IMFGOXM-FNOMAQD-LZFI2RQ-AKOMDZL-B5A2JA2";
          hades.id   =
            "XTWE5SD-D7HSMCA-5XSO5HO-B2WHNXM-TNPCG2O-FCHX3GJ-65P6ZGY-SYCPHQQ";
          iris.id    =
            "24Q2MFE-4ONJZ5U-3GFUM4T-XTKCS42-55V33SU-YUZTVBR-UXOJ4WK-MUQD3AD";
        };
        folders = {
          "jupblb/Documents".devices = [ "artemis" "hades" "iris" ];
          "jupblb/Pictures".devices  = [ "hades" "iris" ];
        };
      };
      group               = "users";
      openDefaultPorts    = true;
    };
  };

  sound.enable = true;

  system.activationScripts.bin-bash = lib.stringAfter [ "usrbinenv" ] ''
    ln -sfn ${pkgs.bashInteractive}/bin/bash /bin/bash
  '';

  time.timeZone = "Europe/Warsaw";

  users.users.jupblb = {
    description                 = "Michal Kielbowicz";
    extraGroups                 = [ "lp" "networkmanager" "wheel" ];
    initialPassword             = "changeme";
    isNormalUser                = true;
    openssh.authorizedKeys.keys = [
      (builtins.readFile ../config/ssh/id_ed25519.pub)
    ];
  };
}
