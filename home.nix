{ config, lib, pkgs, ... }:

{
  home.packages         = with pkgs; [
    bazel bazel-compdb
    clang
    ranger
    screen sway
    unzip
    xdg-user-dirs
  ];
  home.sessionVariables = {
    BAT_THEME            = "gruvbox";
    EDITOR               = "vim";
    MANPAGER             = "vim -c 'set ft=man' -";
    NIXPKGS_ALLOW_UNFREE = "1";
  };
  home.stateVersion     = "20.03";

  nixpkgs.config.allowUnfree      = true;
  nixpkgs.config.packageOverrides =
    let unstable = import <nixpkgs-unstable> {
      config.allowUnfree = true;
      overlays           = [ (import ./overlays) ];
    };
    in pkgs: {
      bat          = unstable.bat;
      bazel        = unstable.bazel;
      bazel-compdb = unstable.bazel-compdb';
      emacsGtk     = unstable.emacs';
      gitAndTools  = pkgs.gitAndTools // {
        delta = unstable.gitAndTools.delta;
      };
      lsd          = unstable.lsd';
      sway         = unstable.sway';
      ranger       = unstable.ranger';
    };

  programs = {
    # Remember to run `bat cache --build` before first run
    bat.enable         = true;
    bat.themes.gruvbox = builtins.readFile ./misc/gruvbox.tmTheme;

    emacs.enable  = true;
    emacs.package = pkgs.emacsGtk;

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
      interactiveShellInit = builtins.readFile ./misc/config.fish;
      plugins              = [ {
        name = "gruvbox";
        src  = pkgs.fetchFromGitHub {
          owner  = "Jomik";
          repo   = "fish-gruvbox";
          rev    = "d8c0463518fb95bed8818a1e7fe5da20cffe6fbd";
          sha256 = "0hkps4ddz99r7m52lwyzidbalrwvi7h2afpawh9yv6a226pjmck7";
        };
      } ];
      shellAliases         = with pkgs; {
        cat       = "${bat}/bin/bat -p --paging=never";
        less      = "${bat}/bin/bat -p --paging=always";
        ls        = "${lsd}/bin/lsd --date relative";
        nix-shell = "nix-shell --command fish";
      };
    };

    fzf.defaultOptions  = [ "--color=light" ];
    fzf.enable          = true;

    git = {
      delta       = {
        enable  = true;
        options = [
          "--commit-color '#fabd2f'" "--file-color '#076678'"
          "--hunk-style plain" "--minus-color '#f9d8bc'"
          "--minus-emph-color '#fa9f86'" "--plus-color '#eeebba'"
          "--plus-emph-color '#d9d87f'" "--theme 'gruvbox'" 
        ];
      };
      enable      = true;
      extraConfig = {
        color.ui          = true;
        core.mergeoptions = "--no-edit";
        fetch.prune       = true;
        push.default      = "upstream";
      };
      userEmail   = "mpkielbowicz@gmail.com";
      userName    = "jupblb";
    };

    htop.enable = true;

    i3status.enable        = true;
    i3status.enableDefault = true;

    kitty.enable      = true;
    kitty.extraConfig = with pkgs; ''
      ${builtins.readFile ./misc/kitty.conf}
      ${builtins.readFile (fetchurl {
        url    = "https://raw.githubusercontent.com/dexpota/kitty-themes/master/themes/gruvbox_light.conf";
        sha256 = "1yvg98vll5yp7nadq2k2q6ri9c9jgk5a5syszbxs7bqpgb27nzha";
      })}
      startup_session ${builtins.toString (writeTextFile {	
        name = "kitty-launch";	
        text = "launch fish -C '${fortune}/bin/fortune -sa'";	
      })}
    '';

    neovim = {
      enable       = true;
      extraConfig  = with pkgs; ''
        let $PATH .= ':${lib.makeBinPath [ ripgrep ]}'
        ${builtins.readFile ./misc/init.vim}
      '';
      plugins      = with pkgs.vimPlugins; [
        airline gruvbox-community fzf-vim ranger-vim vim-nix vim-signify
      ];
      vimAlias     = true;
      vimdiffAlias = true;
      withNodeJs   = false;
      withPython   = false;
      withPython3  = false;
      withRuby     = false;
    };

    starship.enable                = true;
    starship.enableFishIntegration = true;
    starship.settings              = {
      add_newline                         = false;
      character.symbol                    = "~>";
      directory.fish_style_pwd_dir_length = 1;
      directory.truncation_length         = 8;
      prompt_order                        = [
        "username" "hostname" "directory" "git_branch" "git_commit" "git_state"
        "git_status" "character"
      ];
    };

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

