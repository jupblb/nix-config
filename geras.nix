{ config, lib, pkgs, ... }:

{
  boot = {
    loader     = {
      generic-extlinux-compatible.enable = true;
      grub.enable                        = false;
    };
    tmpOnTmpfs = lib.mkForce false;
  };

  i18n.supportedLocales = lib.mkForce [ "en_US.UTF-8/UTF-8" ];

  fileSystems = {
    "/" = { device = "/dev/disk/by-label/NIXOS_SD"; fsType = "ext4"; };
  };

  imports = [ ./common/nixos.nix ];

  home-manager.users = lib.mkForce {};

  networking = {
    hostName        = "geras";
    interfaces.eth0 = { useDHCP = true; };
    wireless.enable = false;
  };

  nix.maxJobs = 2;

  programs.gnupg.agent.pinentryFlavor = "curses";

  services.apcupsd.enable   = lib.mkForce false;
  services.syncthing.enable = lib.mkForce false;
}
