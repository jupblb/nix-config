{ config, lib, pkgs, ... }:

let
  userHome = "$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir)";
in {
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

  environment = {
    etc."xdg/user-dirs.defaults".text = builtins.readFile(./misc/user-dirs);
    systemPackages                    = with pkgs.unstable; [
      ammonite'
      file fzf
      gcc git'
      htop 
      neovim'
      paper-icon-theme python3
      ranger' rustup
      sbt'
      unzip
    ];
    variables                         = {
      CARGO_HOME            = "${userHome}/.local/share/cargo";
      EDITOR                = "vim";
      FZF_DEFAULT_OPTS      = "--color=light";
      HISTFILE              = "${userHome}/.cache/bash_history";
      LESSHISTFILE          = "-";
      MANPAGER              = "vim -c 'set ft=man' -";
      NIXPKGS_ALLOW_UNFREE  = "1";
      NPM_CONFIG_USERCONFIG = builtins.toString ./misc/npmrc;
      NVIM_LISTEN_ADDRESS   = "/tmp/nvimsocket";
      RUSTUP_HOME           = "${userHome}/.local/share/rustup";
      XAUTHORITY            = "/tmp/Xauthority";
    };
  };

  fonts.fonts = [ pkgs.vistafonts ];

  hardware = {
    enableRedistributableFirmware = true;
    opengl.enable                 = true;
    pulseaudio.enable             = true;
  };

  i18n.defaultLocale    = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "pl_PL.UTF-8/UTF-8" ];

  networking.useDHCP = false;

  nix.autoOptimiseStore = true;
  nix.gc.automatic      = true;
  nix.gc.dates          = "*-*-1,10,20 12:00:00";

  nixpkgs.config.allowUnfree      = true;
  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import <nixos-unstable> {
      config   = config.nixpkgs.config;
      overlays = config.nixpkgs.overlays;
    };
  };
  nixpkgs.overlays                = [ (import ./overlays) ];

  programs = {
    bash.enableCompletion       = true;
    bash.promptInit             = builtins.readFile(./misc/bashrc);
    bash.shellAliases.ls        = "ls --color=auto";
    evince.enable               = true;
    fish.enable                 = true;
    fish.interactiveShellInit   = ''
      ${builtins.readFile(./misc/fishrc)}
      ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update
    '';
    fish.shellAliases.nix-shell = "nix-shell --command fish";
    fish.shellAliases.ssh       = "env TERM=xterm-256color ssh";
    ssh.extraConfig             = builtins.readFile(./misc/ssh-config);
  };

  services = {
    acpid.enable                         = true;
    openssh.openFirewall                 = true;
    openssh.enable                       = true;
    openssh.passwordAuthentication       = false;
    openssh.permitRootLogin              = "no";
    printing.drivers                     = [
      pkgs.samsung-unified-linux-driver_1_00_37
    ];
    printing.enable                      = true;
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
    description     = "Michal Kielbowicz";
    initialPassword = "changeme";
    isNormalUser    = true;
    extraGroups     = [ "lp" "networkmanager" "wheel" ];
    shell           = pkgs.fish;
  };
}
