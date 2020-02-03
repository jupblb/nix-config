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
    etc."i3/config".text              = with pkgs; ''
      exec --no-startup-id ${dunst}/bin/dunst -conf ${builtins.toString ./misc/wm/dunstrc}
      exec ${redshift}/bin/redshift -l 51.12:17.05 
      set $browser env QT_SCALE_FACTOR=2 ${qutebrowser}/bin/qutebrowser --basedir ~/.config/.qtbrowserx
      set $menu ${dmenu}/bin/dmenu_path | ${dmenu}/bin/dmenu_run \
        -fn 'PragmataPro Mono Liga:bold:pixelsize=40' -nb '#282828' -nf '#f9f5d7' -sb '#f9f5d7' -sf '#282828'
      set $print ${gnome3.gnome-screenshot}/bin/gnome-screenshot -i
      ${builtins.readFile(./misc/wm/common-config)}
      ${builtins.readFile(./misc/wm/i3-config)}
    '';
    etc."sway/config".text            = with pkgs; ''
      output * background ${builtins.toString ./misc/wm/wallpaper.png} fill
      exec ${mako}/bin/mako -c ${builtins.toString ./misc/wm/mako-config}
      exec ${redshift'}/bin/redshift -m wayland -l 51.12:17.05 
      set $browser ${qutebrowser}/bin/qutebrowser
      set $menu ${bemenu}/bin/bemenu-run \
        --fn 'PragmataPro 12' -p "" --fb '$bg' --ff '$fg' --hb '$green' --hf '$fg' --nb '$bg' --nf '$fg' \
        --sf '$bg' --sb '$fg' --tf '$fg' --tb '$bg' | xargs swaymsg exec --
      set $print ${grim}/bin/grim $(xdg-user-dir PICTURES)/screenshots/$(date +'%s_grim.png')
      ${builtins.readFile(./misc/wm/common-config)}
      ${builtins.readFile(./misc/wm/sway-config)}
      bindsym $mod+Print exec ${grim}/bin/grim -g "$(slurp)" $(xdg-user-dir PICTURES)/screenshots/$(date +'%s_grim.png')
    '';
    etc."X11/xinit/xinitrc".text      = ''
      ${pkgs.feh}/bin/feh --bg-scale ${builtins.toString ./misc/wm/wallpaper.png}
      exec i3
    '';
    etc."xdg/user-dirs.defaults".text = builtins.readFile(./misc/conf/user-dirs);
    ld-linux                          = true;
    shells                            = with pkgs; [ fish bashInteractive ];
    systemPackages                    = with pkgs.unstable; [
      _1password'
      ammonite
      dropbox-cli
      file
      fzf
      ghc
      git'
      htop
      kitty'
      lm_sensors
      sbt'
      unzip
      vim'
      xdg-user-dirs
    ];
    variables                         = {
      NIXPKGS_ALLOW_UNFREE = "1";
      OMF_CONFIG           = builtins.toString ./misc/conf/omf;
      OMF_PATH             = builtins.toString ./misc/omf;
    };
  };

  fonts.fonts = with pkgs; [ vistafonts ];

  hardware.cpu.intel.updateMicrocode     = true;
  hardware.enableRedistributableFirmware = true;
  hardware.opengl.enable                 = true;
  hardware.pulseaudio.enable             = true;

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
  programs.mosh.enable                  = true;
  programs.mosh.withUtempter            = true;
  programs.nano.nanorc                  = builtins.readFile(./misc/scripts/nanorc);
  programs.ssh.extraConfig              = builtins.readFile(./misc/conf/ssh-config);
  programs.sway.enable                  = true;
  programs.sway.extraPackages           = with pkgs.unstable; [
    i3status'
    imv
    mpv
    paper-icon-theme
    pavucontrol
    wob
    zoom-us
  ];
  programs.sway.extraSessionCommands    = builtins.readFile(./misc/scripts/sway.sh);
  programs.sway.wrapperFeatures.gtk     = true;
  programs.vim.defaultEditor            = true;
  
  services.acpid.enable                           = true;
  services.dbus.packages                          = [ pkgs.gnome3.dconf ];
  services.mingetty.autologinUser                 = "jupblb";
  services.openssh.openFirewall                   = true;
  services.openssh.enable                         = true;
  services.openssh.passwordAuthentication         = false;
  services.openssh.permitRootLogin                = "no";
  services.printing.drivers                       = [ pkgs.samsung-unified-linux-driver_1_00_37 ];
  services.printing.enable                        = true;
  services.xserver.displayManager.startx.enable   = true;
  services.xserver.enable                         = true;
  services.xserver.layout                         = "pl";
  services.xserver.windowManager.i3.extraPackages = with pkgs.unstable; [
    franz
    i3status'
    idea-ultimate'
    imv
    mpv
    paper-icon-theme
    pavucontrol
    zoom-us
  ];
  services.xserver.windowManager.i3.package       = pkgs.i3';

  sound.enable = true;

  system.activationScripts.bin-bash = lib.stringAfter [ "usrbinenv" ] ''
    ln -sf ${pkgs.bashInteractive}/bin/bash /bin/bash
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
