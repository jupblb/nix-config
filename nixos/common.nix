{ config, lib, pkgs, ... }:

let
  userHome = "$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir)";
in {
  boot = {
    initrd.availableKernelModules               = [
      "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"
    ];
    kernel.sysctl."fs.inotify.max_user_watches" = 524288;
    kernel.sysctl."vm.swappiness"               = 20;
    kernelPackages                              = pkgs.linuxPackages_latest;
    kernelParams                                = [ "mitigations=off" ];
    loader.efi.canTouchEfiVariables             = true;
    loader.systemd-boot.enable                  = true;
    loader.timeout                              = 1;
    supportedFilesystems                        = [ "ntfs" "exfat" ];
  };

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
      dropbox-cli
      file fzf
      gcc git'
      htop 
      kitty'
      neovim'
      paper-icon-theme
      ranger' rustup
      sbt'
      unzip
    ];
    variables                         = {
      CARGO_HOME            = "${userHome}/.local/share/cargo";
      EDITOR                = "vim";
      FZF_DEFAULT_OPTS      = "--color=light";
      GNUPGHOME             = "${userHome}/.local/share/gnupg";
      HISTFILE              = "${userHome}/.cache/bash_history";
      LESSHISTFILE          = "-";
      NIXPKGS_ALLOW_UNFREE  = "1";
      NPM_CONFIG_USERCONFIG = builtins.toString ./misc/npmrc;
      NVIM_LISTEN_ADDRESS   = "/tmp/nvimsocket";
      RUSTUP_HOME           = "${userHome}/.local/share/rustup";
      XAUTHORITY            = "/tmp/Xauthority";
    };
  };

  fonts.fonts = [ pkgs.vistafonts ];

  hardware = {
    cpu.intel.updateMicrocode     = true;
    enableRedistributableFirmware = true;
    opengl.enable                 = true;
    opengl.extraPackages          = with pkgs; [ libvdpau-va-gl vaapiVdpau ];
    pulseaudio.enable             = true;
    pulseaudio.package            = pkgs.pulseaudioFull;
  };

  i18n.defaultLocale    = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "pl_PL.UTF-8/UTF-8" ];

  networking.nameservers           = [ "1.1.1.1" "8.8.8.8" ];
  networking.networkmanager.enable = true;
  networking.useDHCP               = false;

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
    bash.enableCompletion        = true;
    bash.promptInit              = builtins.readFile(./misc/bashrc);
    bash.shellAliases.ls         = "ls --color=auto";
    evince.enable                = true;
    fish.enable                  = true;
    fish.interactiveShellInit    = with pkgs; ''
      set __fish_git_prompt_showdirtystate "yes"
      set __fish_git_prompt_showuntrackedfiles "yes"
      ${xdg-user-dirs}/bin/xdg-user-dirs-update
      function fish_greeting; ${fortune}/bin/fortune -sa; end
    '';
    fish.shellAliases.nix-shell  = "nix-shell --command fish";
    ssh.extraConfig              = builtins.readFile(./misc/ssh-config);
  };

  services = {
    acpid.enable                         = true;
    fstrim.enable                        = true;
    fwupd.enable                         = true;
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

  systemd.services.dropbox = {
    after                        = [ "network.target" ];
    description                  = "Dropbox";
    environment.QML2_IMPORT_PATH = ''
      ${pkgs.qt5.qtbase}${pkgs.qt5.qtbase.qtQmlPrefix}
    '';
    environment.QT_PLUGIN_PATH   = ''
      ${pkgs.qt5.qtbase}${pkgs.qt5.qtbase.qtPluginPrefix}
    '';
    serviceConfig                = {
      ExecStart     = "${pkgs.dropbox}/bin/dropbox";
      ExecReload    = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      KillMode      = "control-group";
      Nice          = 10;
      PrivateTmp    = true;
      ProtectSystem = "full";
      Restart       = "on-failure";
      User          = "jupblb";
    };
    wantedBy                     = [ "default.target" ];
  };

  time.timeZone = "Europe/Warsaw";

  users.users.jupblb = {
    description     = "Michal Kielbowicz";
    initialPassword = "changeme";
    isNormalUser    = true;
    extraGroups     = [ "lp" "networkmanager" "wheel" ];
    shell           = pkgs.fish;
  };
}
