{ config, lib, pkgs, ... }:

{
  boot.earlyVconsoleSetup = true;
  boot.kernelPackages     = pkgs.linuxPackages_latest;
  boot.loader.timeout     = 1;
  boot.tmpOnTmpfs         = true;

  environment.shells         = with pkgs; [ fish bashInteractive ];
  environment.systemPackages = with pkgs.unstable; [
    all-hies'
    ammonite
    diff-so-fancy'
    dropbox-cli
    file
    firefox
    fzf
    git
    htop
    imv
    kitty
    ltunify
    mpv
    pciutils
    ranger
    sbt'
    spotify
    unzip
    vim'
    virt-manager
    vscode
  ];

  fonts.fontconfig.defaultFonts.monospace = [ "Iosevka" ];
  fonts.fonts                             = with pkgs.unstable; [ iosevka-bin vistafonts ];

  hardware.enableRedistributableFirmware = true;

  i18n = {
    consoleColors    = [
      "bdae93"
      "c74545"
      "6c782e"
      "c55b03"
      "47747e"
      "945e80"
      "4c7a5d"
      "764e37"
      "928374"
      "c74545"
      "6c782e"
      "b47109"
      "47747e"
      "945e80"
      "4c7a5d"
      "764e37"
    ];
    consoleKeyMap    = "pl";
    defaultLocale    = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "pl_PL.UTF-8/UTF-8" ];
  };

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.useDHCP     = false;

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

  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.scsiLinkPolicy  = "min_power";

  programs.adb.enable                   = true;
  programs.bash.enableCompletion        = true;
  programs.bash.promptInit              = builtins.readFile(./scripts/bashrc);
  programs.bash.shellAliases            = { ls = "ls --color=auto"; };
  programs.evince.enable                = true;
  programs.fish.enable                  = true;
  programs.fish.interactiveShellInit    = "${pkgs.fortune}/bin/fortune -sa";
  programs.fish.shellAliases            = { nix-shell = "nix-shell --command fish"; };
  programs.gnupg.agent.enable           = true;
  programs.gnupg.agent.enableSSHSupport = true;
  programs.less.enable                  = false;
  programs.nano.nanorc                  = builtins.readFile(./scripts/nanorc);
  programs.ssh.forwardX11               = true;
  programs.sway.enable                  = true;
  programs.sway.extraPackages           = with pkgs.unstable; [
    dmenu
    franz
    grim
    i3status
    idea-ultimate'
    mako
    paper-icon-theme
    redshift-wayland'
    swaylock
    slurp
    waypipe
    xdg-user-dirs
    xwayland
    zoom-us
  ];
  programs.sway.extraSessionCommands    = builtins.readFile(./scripts/swayrc);
  programs.vim.defaultEditor            = true;

  services.mingetty.autologinUser  = "jupblb";
  services.openssh.enable          = true;
  services.openssh.forwardX11      = true;
  services.openssh.permitRootLogin = "no";
  services.printing.drivers        = [ pkgs.samsung-unified-linux-driver_1_00_37 ];
  services.printing.enable         = true;

  system.activationScripts.ld-linux = lib.stringAfter [ "usrbinenv" ] ''                       
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2
  '';
  system.activationScripts.bin-bash = lib.stringAfter [ "usrbinenv" ] ''
    ln -sf /run/current-system/sw/bin/bash /bin/bash
  '';
  system.extraSystemBuilderCmds     = with pkgs; ''
    mkdir -p $out/pkgs
    ln -s ${openjdk8 } $out/pkgs/openjdk8
    ln -s ${openjdk  } $out/pkgs/openjdk
    ln -s ${graalvm8 } $out/pkgs/graalvm8-ce
  '';

  systemd.user.services.dropbox = {
    description                  = "Dropbox";
    wantedBy                     = [ "default.target" ];
    environment.QT_PLUGIN_PATH   = "/run/current-system/sw/${pkgs.qt5.qtbase.qtPluginPrefix}";
    environment.QML2_IMPORT_PATH = "/run/current-system/sw/${pkgs.qt5.qtbase.qtQmlPrefix}";
    serviceConfig                = {
      ExecStart     = "${pkgs.dropbox.out}/bin/dropbox";
      ExecReload    = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
      KillMode      = "control-group";
      Restart       = "on-failure";
      PrivateTmp    = true;
      ProtectSystem = "full";
      Nice          = 10;
    };
  };

  time.timeZone = "Europe/Warsaw";

  users.users.jupblb = {
    createHome      = true;
    description     = "Michal Kielbowicz";
    group           = "users";
    home            = "/home/jupblb";
    initialPassword = "changeme";
    isNormalUser    = true;
    extraGroups     = [ "wheel" "lp" "libvirtd" ];
    shell           = pkgs.fish;
  };
}
