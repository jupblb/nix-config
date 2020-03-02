{ config, lib, pkgs, ... }:

{
  boot = {
    kernel.sysctl."fs.inotify.max_user_watches" = 524288;
    kernel.sysctl."vm.swappiness"               = 20;
    kernelPackages                              = pkgs.linuxPackages_latest;
    kernelParams                                = [ "mitigations=off" "no_stf_barrier" "noibpb" "noibrs" ];
    loader.efi.canTouchEfiVariables             = true;
    loader.systemd-boot.enable                  = true;
    loader.systemd-boot.memtest86.enable        = true;
    loader.timeout                              = 1;
    supportedFilesystems                        = [ "ntfs" "exfat" ];
  };

  console.colors     = [
    "f9f5d7"
    "cc241d"
    "98971a"
    "d79921"
    "458588"
    "b16286"
    "689d6a"
    "7c6f64"
    "928374"
    "9d0006"
    "79740e"
    "b57614"
    "076678"
    "8f3f71"
    "427b58"
    "3c3836"
  ];
  console.earlySetup = true;
  console.keyMap     = "pl";

  environment = {
    etc."xdg/user-dirs.defaults".text = builtins.readFile(./misc/user-dirs);
    systemPackages                    = with pkgs.unstable; [
      ammonite'
      dropbox-cli
      file
      fzf
      ghc
      git'
      htop kitty'
      lm_sensors
      pkgs.neovim'
      paper-icon-theme
      rustup
      sbt'
      unzip
    ];
    variables                         = {
      _JAVA_OPTIONS         = ''-Djava.util.prefs.userRoot=$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir)/.config/java'';
      GNUPGHOME             = "$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir)/.local/share/gnupg";
      HISTFILE              = "$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir)/.cache/bash_history";
      LESSHISTFILE          = "-";
      NIXPKGS_ALLOW_UNFREE  = "1";
      NPM_CONFIG_USERCONFIG = builtins.toString ./misc/npmrc;
      XAUTHORITY            = "/tmp/Xauthority";
    };
  };

  fonts.fonts = [ pkgs.vistafonts ];

  hardware = {
    bluetooth.enable              = true;
    bluetooth.package             = pkgs.bluezFull;
    cpu.intel.updateMicrocode     = true;
    enableRedistributableFirmware = true;
    opengl.enable                 = true;
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
  nix.gc.dates          = "weekly";

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
    bash.shellAliases            = { ls = "ls --color=auto"; };
    dconf.enable                 = true;
    evince.enable                = true;
    fish.enable                  = true;
    fish.interactiveShellInit    = ''
      set -g __fish_git_prompt_showdirtystate "yes"
      set -g __fish_git_prompt_showuntrackedfiles "yes"
      ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update
      function fish_greeting; ${pkgs.fortune}/bin/fortune -sa; end
    '';
    fish.shellAliases            = { nix-shell = "nix-shell --command fish"; };
    gnupg.agent.enable           = true;
    gnupg.agent.enableSSHSupport = true;
    ssh.extraConfig              = builtins.readFile(./misc/ssh-config);
    vim.defaultEditor            = true;
  };

  services = {
    acpid.enable                         = true;
    fstrim.enable                        = true;
    openssh.openFirewall                 = true;
    openssh.enable                       = true;
    openssh.passwordAuthentication       = false;
    openssh.permitRootLogin              = "no";
    printing.drivers                     = [ pkgs.samsung-unified-linux-driver_1_00_37 ];
    printing.enable                      = true;
  };

  sound.enable = true;

  system.activationScripts.bin-bash = lib.stringAfter [ "usrbinenv" ] ''
    ln -sf ${pkgs.bashInteractive}/bin/bash /bin/bash
  '';
  system.activationScripts.ld-linux = lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2
  '';

  systemd.user.services.dropbox = {
    description                  = "Dropbox";
    environment.QT_PLUGIN_PATH   = "${pkgs.qt5.qtbase}${pkgs.qt5.qtbase.qtPluginPrefix}";
    environment.QML2_IMPORT_PATH = "${pkgs.qt5.qtbase}${pkgs.qt5.qtbase.qtQmlPrefix}";
    serviceConfig                = {
      ExecStart     = "${pkgs.dropbox}/bin/dropbox";
      ExecReload    = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      KillMode      = "control-group";
      Restart       = "on-failure";
      PrivateTmp    = true;
      ProtectSystem = "full";
      Nice          = 10;
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
