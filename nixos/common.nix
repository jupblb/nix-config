{ config, lib, pkgs, ... }:

{
  boot = {
    kernel.sysctl."fs.inotify.max_user_watches" = 524288;
    kernel.sysctl."kernel.kptr_restrict"        = 0;
    kernel.sysctl."kernel.perf_event_paranoid"  = 1;
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
    etc            = {
      "gitconfig".text              = with pkgs; ''
        ${builtins.readFile(./misc/conf/git/gitconfig)}
        [core]
        ${"\t"}editor = ${vim'}/bin/vim
        ${"\t"}excludesfile = ${./misc/conf/git/gitignore}
        ${"\t"}mergeoptions = --no-edit
        [diff]
        ${"\t"}tool = ${vim'}/bin/vim -d
        [pager]
        ${"\t"}diff = ${gitAndTools.diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX
        ${"\t"}show = ${gitAndTools.diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX
      '';
      "i3/config".text              = with pkgs; ''
        exec --no-startup-id ${dunst}/bin/dunst -conf ${./misc/wm/dunstrc}
        exec --no-startup-id ${redshift}/bin/redshift -l 51.12:17.05 
        set $browser env QT_SCALE_FACTOR=2 ${qutebrowser}/bin/qutebrowser --basedir ~/.config/.qtbrowserx
        set $menu ${dmenu}/bin/dmenu_path | ${dmenu}/bin/dmenu_run \
          -fn 'PragmataPro Mono Liga:bold:pixelsize=40' -nb '#282828' -nf '#f9f5d7' -sb '#f9f5d7' -sf '#282828'
        set $print ${gnome3.gnome-screenshot}/bin/gnome-screenshot -i --display=:0
        ${builtins.readFile(./misc/wm/common-config)}
        ${builtins.readFile(./misc/wm/i3-config)}
      '';
      "sway/config".text            = with pkgs; ''
        output * background ${./misc/wm/wallpaper.png} fill
        exec --no-startup-id ${mako}/bin/mako -c ${./misc/wm/mako-config}
        exec --no-startup-id ${redshift'}/bin/redshift -m wayland -l 51.12:17.05 
        set $browser ${qutebrowser}/bin/qutebrowser
        set $menu ${bemenu}/bin/bemenu-run \
          --fn 'PragmataPro 12' -p "" --fb '$bg' --ff '$fg' --hb '$green' --hf '$fg' --nb '$bg' --nf '$fg' \
          --sf '$bg' --sb '$fg' --tf '$fg' --tb '$bg' | xargs swaymsg exec --
        set $print ${grim}/bin/grim $(${xdg-user-dirs}/bin/xdg-user-dir PICTURES)/screenshots/$(date +'%s_grim.png')
        ${builtins.readFile(./misc/wm/common-config)}
        ${builtins.readFile(./misc/wm/sway-config)}
        bindsym $mod+Print exec ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" $(${xdg-user-dirs}/bin/xdg-user-dir PICTURES)/screenshots/$(date +'%F_%R:%S_grim.png')
      '';
      "X11/xinit/xinitrc".text      = ''
        ${pkgs.feh}/bin/feh --bg-scale ${./misc/wm/wallpaper.png}
        exec i3
      '';
      "xdg/user-dirs.defaults".text = builtins.readFile(./misc/conf/user-dirs);
    };
    shells         = with pkgs; [ fish bashInteractive ];
    systemPackages = with pkgs.unstable; [
      ammonite' dropbox-cli file fzf ghc git htop kitty' lm_sensors sbt' unzip vim'
    ];
    variables      = {
      _JAVA_OPTIONS         = ''-Djava.util.prefs.userRoot=$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir)/.config/java'';
      GNUPGHOME             = "~/.local/share/gnupg";
      HISTFILE              = "~/.cache/bash_history";
      LESSHISTFILE          = "-";
      LESSKEY               = "~/.config/lesskey";
      NIXPKGS_ALLOW_UNFREE  = "1";
      NPM_CONFIG_USERCONFIG = builtins.toString ./misc/rc/npmrc;
      OMF_CONFIG            = builtins.toString ./misc/conf/omf;
      OMF_PATH              = builtins.toString ./misc/omf;
      XAUTHORITY            = "/tmp/Xauthority";
    };
  };

  fonts.fonts = with pkgs; [ vistafonts ];

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
    bash.promptInit              = builtins.readFile(./misc/rc/bashrc);
    bash.shellAliases            = { ls = "ls --color=auto"; };
    dconf.enable                 = true;
    evince.enable                = true;
    fish.enable                  = true;
    fish.interactiveShellInit    = ''
      ${builtins.readFile(./misc/rc/init.fish)}
      ${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update
      ${pkgs.fortune}/bin/fortune -sa
    '';
    fish.shellAliases            = { nix-shell = "nix-shell --command fish"; };
    fish.shellInit               = "source $OMF_PATH/init.fish";
    gnupg.agent.enable           = true;
    gnupg.agent.enableSSHSupport = true;
    nano.nanorc                  = builtins.readFile(./misc/rc/nanorc);
    ssh.extraConfig              = builtins.readFile(./misc/conf/ssh-config);
    sway.enable                  = true;
    sway.extraPackages           = with pkgs.unstable; [
      i3status' imv mpv paper-icon-theme pavucontrol wob zoom-us
    ];
    sway.extraSessionCommands    = builtins.readFile(./misc/rc/sway.sh);
    sway.wrapperFeatures.gtk     = true;
    vim.defaultEditor            = true;
  };

  services = {
    acpid.enable                           = true;
    dbus.packages                          = [ pkgs.gnome3.dconf ];
    openssh.openFirewall                   = true;
    openssh.enable                         = true;
    openssh.passwordAuthentication         = false;
    openssh.permitRootLogin                = "no";
    printing.drivers                       = [ pkgs.samsung-unified-linux-driver_1_00_37 ];
    printing.enable                        = true;
    xserver.displayManager.startx.enable   = true;
    xserver.enable                         = true;
    xserver.layout                         = "pl";
    xserver.windowManager.i3.extraPackages = with pkgs.unstable; [
      franz i3status' idea-ultimate' imv mpv paper-icon-theme pavucontrol zoom-us
    ];
    xserver.windowManager.i3.package       = pkgs.i3';
  };

  sound.enable = true;

  system.activationScripts.bin-bash = lib.stringAfter [ "usrbinenv" ] ''
    ln -sf ${pkgs.bashInteractive}/bin/bash /bin/bash
  '';
  system.activationScripts.ld-linux = lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2
  '';

  systemd.user.services.dropbox = {
    description                  = "Dropbox";
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
    wantedBy                     = [ "default.target" ];
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
