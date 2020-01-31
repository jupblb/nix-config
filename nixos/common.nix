{ config, lib, pkgs, ... }:

{
  boot = {
    earlyVconsoleSetup                          = true;
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

  environment = {
    etc."xdg/user-dirs.defaults".text = ''
      DESKTOP=""
      DOWNLOAD=downloads
      TEMPLATES=""
      PUBLICSHARE=public
      DOCUMENTS=documents
      MUSIC=music
      PICTURES=pictures
      VIDEOS=pictures
    '';
#   ld-linux                          = true;
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

  fonts.fonts = with pkgs; [ nerdfonts vistafonts ];

  hardware.cpu.intel.updateMicrocode     = true;
  hardware.enableRedistributableFirmware = true;
  hardware.opengl.enable                 = true;
  hardware.pulseaudio.enable             = true;

  i18n = {
    consoleColors    = [
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
    consoleKeyMap    = "pl";
    defaultLocale    = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "pl_PL.UTF-8/UTF-8" ];
  };


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
  programs.vim.defaultEditor            = true;
  
  services.acpid.enable                           = true;
  services.dbus.packages                          = [ pkgs.gnome3.dconf ];
  services.openssh.enable                         = true;
  services.openssh.permitRootLogin                = "no";
  services.printing.drivers                       = [ pkgs.samsung-unified-linux-driver_1_00_37 ];
  services.printing.enable                        = true;
  services.xserver.desktopManager.default         = "none";
  services.xserver.displayManager.auto.enable     = true;
  services.xserver.displayManager.auto.user       = "jupblb";
  services.xserver.dpi                            = 220;
  services.xserver.enable                         = true;
  services.xserver.layout                         = "pl";
  services.xserver.windowManager.default          = "i3";
  services.xserver.windowManager.i3.enable        = true;
  services.xserver.windowManager.i3.extraPackages = with pkgs.unstable; [
    dmenu
    dunst
    firefox
    franz
    gnome-screenshot'
    i3status
    idea-ultimate'
    imv
    mpv
    paper-icon-theme
    pavucontrol
    redshift
    zoom-us
  ];
  services.xserver.windowManager.i3.package       = pkgs.unstable.i3-gaps;

  sound.enable = true;

  system.activationScripts.bin-bash = lib.stringAfter [ "usrbinenv" ] ''
    ln -sf ${pkgs.bashInteractive}/bin/bash /bin/bash
  '';
  system.activationScripts.ld-linux = lib.stringAfter [ "usrbinenv" ] ''                       
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2
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
