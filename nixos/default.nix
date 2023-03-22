{ config, lib, pkgs, ... }:

{
  console = {
    earlySetup = true;
    keyMap     = "pl";
  };

  environment.sessionVariables = { NIXPKGS_ALLOW_UNFREE = "1"; };
  environment.systemPackages   = with pkgs; [ file unzip ];

  hardware.enableRedistributableFirmware = true;

  home-manager.users.jupblb = {
    imports = [ ../home-manager ];

    nixpkgs.config.packageOverrides = _:
      let t = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable-small.tar.gz";
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

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays           = [ (import ../overlay) ];

  programs = {
    bash.enableCompletion = true;
    bash.enableLsColors   = true;
    bash.promptInit       = builtins.readFile ../config/bashrc.bash;
    gnupg.agent.enable    = true;
    vim.defaultEditor     = true;
  };

  services = {
    fstrim.enable = true;

    kmscon = {
      autologinUser = "jupblb";
      enable        = true;
      fonts         = [
        { name = "PragmataPro Mono"; package = pkgs.pragmata-pro; }
        { name = "Source Code Pro"; package = pkgs.source-code-pro; }
      ];
      hwRender      = true;
    };

    openssh = {
      openFirewall           = true;
      enable                 = true;
      passwordAuthentication = false;
      permitRootLogin        = "no";
    };

    sshguard.enable = true;
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
    shell                           = pkgs.fish;
  };
}
