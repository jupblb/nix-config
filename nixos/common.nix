{ config, lib, pkgs, ... }:

let
  hosts = pkgs.fetchurl {
    url = "http://sbc.io/hosts/alternates/fakenews-gambling/hosts";
    sha256 = "sha256:1jjfhdnql44zd47wvvxgw3jwysx5ijmbdy5dnhh7694pq0rl3r9s";
  };
in
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
    tmpOnTmpfs                                  = true;
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
    etc."xdg/user-dirs.defaults".text = builtins.readFile(./misc/xdg/user-dirs);
    ld-linux                          = true;
    shells                            = with pkgs; [ fish bashInteractive ];
    systemPackages                    = with pkgs.unstable; [
      ammonite
      dropbox-cli
      file
      fzf
      ghc
      git'
      htop
      kitty'
      lm_sensors
      neovim''
      sbt'
      unzip
      vim'
      xdg-user-dirs
    ];
    variables                         = {
      OMF_CONFIG = builtins.toString ./misc/omf-conf;
      OMF_PATH   = builtins.toString ./misc/omf;
    };
  };

  fonts.fonts = with pkgs; [ vistafonts ];

  hardware.cpu.intel.updateMicrocode     = true;
  hardware.enableRedistributableFirmware = true;
  hardware.opengl.enable                 = true;
  hardware.pulseaudio.enable             = true;

  i18n.defaultLocale    = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "pl_PL.UTF-8/UTF-8" ];

  networking.extraHosts               = builtins.readFile hosts;
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.nameservers              = [ "1.1.1.1" "8.8.8.8" ];
  networking.networkmanager.enable    = true;
  networking.useDHCP                  = false;

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

  programs.bash.enableCompletion        = true;
  programs.bash.promptInit              = builtins.readFile(./misc/scripts/bashrc);
  programs.bash.shellAliases            = { ls = "ls --color=auto"; };
  programs.dconf.enable                 = true;
  programs.evince.enable                = true;
  programs.fish.enable                  = true;
  programs.fish.interactiveShellInit    = ''
    ${builtins.readFile(./misc/scripts/init.fish)}
    ${pkgs.fortune}/bin/fortune -sa
  '';
  programs.fish.shellAliases            = { nix-shell = "nix-shell --command fish"; };
  programs.fish.shellInit               = "source $OMF_PATH/init.fish";
  programs.gnupg.agent.enable           = true;
  programs.gnupg.agent.enableSSHSupport = true;
  programs.nano.nanorc                  = builtins.readFile(./misc/scripts/nanorc);
  programs.ssh.extraConfig              = builtins.readFile(./misc/ssh/config);
  programs.sway.enable                  = true;
  programs.sway.extraPackages           = with pkgs.unstable; [
    bemenu
    grim
    i3status
    imv
    mako
    mpv
    paper-icon-theme
    pavucontrol
    redshift'
    slurp
    qutebrowser
    wob
    zoom-us
  ];
  programs.sway.extraSessionCommands    = builtins.readFile(./misc/scripts/sway.sh);
  programs.sway.wrapperFeatures.gtk     = true;
  programs.vim.defaultEditor            = true;
  
  services.acpid.enable                                    = true;
  services.dbus.packages                                   = [ pkgs.gnome3.dconf ];
  services.mingetty.autologinUser                          = "jupblb";
  services.openssh.enable                                  = true;
  services.openssh.permitRootLogin                         = "no";
  services.printing.drivers                                = [ pkgs.samsung-unified-linux-driver_1_00_37 ];
  services.printing.enable                                 = true;
  services.xserver.displayManager.startx.enable            = true;
  services.xserver.enable                                  = true;
  services.xserver.layout                                  = "pl";
  services.xserver.windowManager.i3.enable                 = true;
  services.xserver.windowManager.i3.extraPackages          = with pkgs.unstable; [
    dmenu
    dunst
    feh
    franz
    gnome-screenshot'
    i3status
    idea-ultimate'
    imv
    mpv
    paper-icon-theme
    pavucontrol
    qutebrowser
    redshift'
    zoom-us
  ];
  services.xserver.windowManager.i3.package                = pkgs.unstable.i3-gaps;

  sound.enable = true;

  system.activationScripts.bin-bash = lib.stringAfter [ "usrbinenv" ] ''
    ln -sf ${pkgs.bashInteractive}/bin/bash /bin/bash
  '';
  system.extraSystemBuilderCmds     = with pkgs.unstable; ''
    mkdir -p $out/pkgs
    ln -s ${openjdk8 } $out/pkgs/openjdk8
    ln -s ${openjdk  } $out/pkgs/openjdk
    ln -s ${graalvm8 } $out/pkgs/graalvm8-ce
  '';

  systemd.user.services.dropbox = {
    description                  = "Dropbox";
    wantedBy                     = [ "default.target" ];
    environment.QT_PLUGIN_PATH   = "${pkgs.qt5.qtbase}${pkgs.qt5.qtbase.qtPluginPrefix}";
    environment.QML2_IMPORT_PATH = "${pkgs.qt5.qtbase}${pkgs.qt5.qtbase.qtQmlPrefix}";
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
    extraGroups     = [ "lp" "networkmanager" "wheel" ];
    shell           = pkgs.fish;
  };
}
