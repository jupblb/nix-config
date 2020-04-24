{ config, lib, pkgs, ... }:

let
  userHome = "$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir)";
in {
  home.packages         = with pkgs.unstable; [
    ammonite' file gcc neovim' python3 ranger' rustup sbt unzip
  ];
  home.sessionVariables = {
    CARGO_HOME            = "${userHome}/.local/share/cargo";
    EDITOR                = "vim";
    HISTFILE              = "${userHome}/.cache/bash_history";
    LESSHISTFILE          = "-";
    MANPAGER              = "vim -c 'set ft=man' -";
    NPM_CONFIG_USERCONFIG = builtins.toString ./misc/npmrc;
    NVIM_LISTEN_ADDRESS   = "/tmp/nvimsocket";
    RUSTUP_HOME           = "${userHome}/.local/share/rustup";
  };
  home.stateVersion     = "20.03";

  nixpkgs.config.allowUnfree      = true;
  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import <nixpkgs-unstable> {
      config   = config.nixpkgs.config;
      overlays = config.nixpkgs.overlays;
    };
  };
  nixpkgs.overlays                = [ (import ./overlays) ];

  programs = {
    bat.enable         = true;
    bat.config.theme   = "gruvbox";
    bat.themes.gruvbox = builtins.readFile(./misc/gruvbox.tmTheme);

    firefox = {
      enable            = true;
      package           = pkgs.unstable.firefox-wayland;
      profiles."jupblb" = {
        extraConfig = builtins.readFile(./misc/firefox/user.js);
        userContent = builtins.readFile(./misc/firefox/user.css);
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
      enable    = true;
      ignores   = [ ".bloop" ".metals" ".idea" "metals.sbt" ".factorypath" ];
      package   = pkgs.git';
      userEmail = "mpkielbowicz@gmail.com";
      userName  = "jupblb";
    };

    htop.enable = true;

    kitty.enable      = true;
    kitty.extraConfig = builtins.readFile(./misc/kitty.conf);

    qutebrowser.enable = true;

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

