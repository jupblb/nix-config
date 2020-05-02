{ config, lib, pkgs, ... }:

{
  boot.kernelParams         = [ "mitigations=off" ];
  boot.loader.timeout       = 3;
  boot.supportedFilesystems = [ "ntfs" "exfat" ];

  console.colors     = [
    "f9f5d7" "cc241d" "98971a" "d79921"
    "458588" "b16286" "689d6a" "7c6f64"
    "928374" "9d0006" "79740e" "b57614"
    "076678" "8f3f71" "427b58" "3c3836"
  ];
  console.earlySetup = true;
  console.keyMap     = "pl";

  environment.sessionVariables =  {
    CARGO_HOME            = "\$HOME/.local/share/cargo";
    EDITOR                = "vim";
    HISTFILE              = "\$HOME/.cache/bash_history";
    LESSHISTFILE          = "-";
    MANPAGER              = "vim -c 'set ft=man' -";
    NIXPKGS_ALLOW_UNFREE  = "1";
    NPM_CONFIG_USERCONFIG = builtins.toString ./misc/npmrc;
    NVIM_LISTEN_ADDRESS   = "/tmp/nvimsocket";
    RUSTUP_HOME           = "\$HOME/.local/share/rustup";
  };
  environment.systemPackages   = with pkgs; [ file git htop unzip vim ];

  fonts.enableDefaultFonts = true;
  fonts.fonts              = with pkgs; [ vistafonts ];

  hardware = {
    enableRedistributableFirmware = true;
    opengl.enable                 = true;
    pulseaudio.enable             = true;
  };

  i18n.defaultLocale    = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "pl_PL.UTF-8/UTF-8" ];

  imports = [ <home-manager/nixos> ];

  networking.useDHCP = false;

  nix.autoOptimiseStore = true;
  nix.gc.automatic      = true;
  nix.gc.dates          = "*-*-1,10,20 12:00:00";

  nixpkgs.config.allowUnfree = true;

  programs = {
    bash.enableCompletion = true;
    bash.promptInit       = builtins.readFile(../misc/bashrc);
    bash.shellAliases.ls  = "ls --color=auto";
    ssh.extraConfig       = builtins.readFile(../misc/ssh-config);
    ssh.startAgent        = true;
  };

  security.pam.services.swaylock.text = "auth include login";

  services = {
    acpid.enable                   = true;
    openssh.openFirewall           = true;
    openssh.enable                 = true;
    openssh.passwordAuthentication = false;
    openssh.permitRootLogin        = "no";
    openssh.ports                  = [ 22 1993 ];
    printing.drivers               = with pkgs; [
      samsung-unified-linux-driver_1_00_37
    ];
    printing.enable                = true;
    sshguard.enable                = true;
  };

  sound.enable = true;

  system.activationScripts.bin-bash = lib.stringAfter [ "usrbinenv" ] ''
    ln -sfn ${pkgs.bashInteractive}/bin/bash /bin/bash
  '';
  system.activationScripts.ld-linux = lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
  '';

  time.timeZone = "Europe/Warsaw";

  users.users.jupblb = {
    description                 = "Michal Kielbowicz";
    extraGroups                 = [ "lp" "networkmanager" "wheel" ];
    initialPassword             = "changeme";
    isNormalUser                = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEtq1CzRgt2HFdkUL7kCx+4r63J9m36CVBtTmIIC4BvN ssh@kielbowi.cz"
    ];
    shell                       = pkgs.bashInteractive;
  };
}
