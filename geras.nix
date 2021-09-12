{ config, lib, pkgs, ... }:

{
  boot.tmpOnTmpfs = lib.mkForce false;

  imports = [ ./common/nixos.nix ];

  home-manager.users = lib.mkForce {};

  networking = {
    hostName        = "geras";
    wireless.enable = false;
  };

  programs.gnupg.agent.pinentryFlavor = "curses";

  services.apcupsd.enable   = lib.mkForce false;
  services.syncthing.enable = lib.mkForce false;
}
