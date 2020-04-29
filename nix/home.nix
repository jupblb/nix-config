{ config, lib, pkgs, ... }:

let
  devPackages = with pkgs.unstable; [
    ammonite' idea-ultimate' neovim' python3 rustup sbt sway'
  ];
in {
  home.packages     = (with pkgs; [
    bemenu
    ferdi'
    imv
    lm_sensors
    mpv
    pavucontrol pciutils
    ranger' remmina
    scp-speed-test'
    unzip usbutils
    zoom-us
  ]) ++ devPackages;
  home.stateVersion = "20.03";

  nixpkgs.config.allowUnfree      = true;
  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import <nixpkgs-unstable> {
      config   = config.nixpkgs.config;
      overlays = config.nixpkgs.overlays;
    };
  };
  nixpkgs.overlays                = [ (import ./overlays) ];

  programs = {
    firefox = {
      enable            = true;
      package           = pkgs.firefox-wayland;
      profiles."jupblb" = {
        extraConfig = builtins.readFile ./misc/firefox/user.js;
        userContent = builtins.readFile ./misc/firefox/user.css;
      };
    };

    fish = {
      enable               = true;
      interactiveShellInit = ''
        function fish_greeting; ${pkgs.fortune}/bin/fortune -sa; end;
        set __fish_git_prompt_showdirtystate "yes"
        set __fish_git_prompt_showuntrackedfiles "yes"
        theme_gruvbox light hard
      '';
      plugins              = [ {
        name = "gruvbox";
        src  = pkgs.fetchFromGitHub {
          owner  = "Jomik";
          repo   = "fish-gruvbox";
          rev    = "d8c0463518fb95bed8818a1e7fe5da20cffe6fbd";
          sha256 = "0hkps4ddz99r7m52lwyzidbalrwvi7h2afpawh9yv6a226pjmck7";
        };
      } ];
      shellAliases         = {
        nix-shell = "nix-shell --command fish";
        ssh       = "env TERM=xterm-256color ssh";
      };
    };

    fzf.defaultOptions  = [ "--color=light" ];
    fzf.enable          = true;

    git = {
      enable      = true;
      extraConfig = {
        color.ui            = true;
        core.mergeoptions   = "--no-edit";
        diff.tool           = "vimdiff";
        fetch.prune         = true;
        merge.conflictstyle = "diff3";
        merge.tool          = "vimdiff";
        push.default        = "upstream";
      };
      ignores     = [ ".bloop" ".metals" ".idea" "metals.sbt" ".factorypath" ];
      userEmail   = "mpkielbowicz@gmail.com";
      userName    = "jupblb";
    };

    htop.enable = true;

    kitty.enable      = true;
    kitty.extraConfig = builtins.readFile ./misc/kitty.conf;

    qutebrowser.enable      = true;
    qutebrowser.extraConfig = "config.load_autoconfig()";

    zathura.enable      = true;
    zathura.extraConfig = "set selection-clipboard clipboard";
  };

  xdg.userDirs = {
    desktop     = "\$HOME/desktop";
    documents   = "\$HOME/documents";
    download    = "\$HOME/downloads";
    enable      = true;
    music       = "\$HOME/music";
    pictures    = "\$HOME/pictures";
    publicShare = "\$HOME/public";
    templates   = "\$HOME";
    videos      = "\$HOME";
  };
}

