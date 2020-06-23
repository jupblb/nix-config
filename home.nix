{ files ? {} }:
{ config, lib, pkgs, ... }:

{
  home.file             = {
    openjdk11   = {
      source = "${pkgs.openjdk11}";
      target = ".local/lib/openjdk11";
    };
    sway-config = {
      target = ".config/sway/config";
      text   = "";
    };
    xsettingsd  = {
      target = ".config/xsettingsd/xsettingsd.conf";
      text   = "Gdk/WindowScalingFactor 2\n";
    };
  } // files;
  home.packages         =
    let
      devPackages  = with pkgs.unstable; [
        aws-cli' ammonite' bazel bear clang idea-ultimate' python3 rustup sbt sway'
      ];
      packages     = with pkgs; [
        discord imv lm_sensors mpv pciutils ranger' unzip usbutils
      ];
      swayPackages = with pkgs; [ bemenu ferdi' pavucontrol remmina zoom-us ];
    in devPackages ++ packages ++ swayPackages;
  home.sessionVariables = {
    AWS_CONFIG_FILE             = "\$HOME/.config/aws/config";
    AWS_SHARED_CREDENTIALS_FILE = "\$HOME/.config/aws/credentials";
    BAT_THEME                   = "gruvbox";
    CARGO_HOME                  = "\$HOME/.local/share/cargo";
    EDITOR                      = "vim";
    HISTFILE                    = "\$HOME/.cache/bash_history";
    LESSHISTFILE                = "-";
    MANPAGER                    = "vim -c 'set ft=man' -";
    NIXPKGS_ALLOW_UNFREE         = "1";
    NPM_CONFIG_USERCONFIG       = builtins.toString ./misc/npmrc;
    PYLINTHOME                  = "\$HOME/.cache/pylint";
    RUSTUP_HOME                 = "\$HOME/.local/share/rustup";
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
    # Remember to run `bat cache --build` before first run
    bat.enable         = true;
    bat.themes.gruvbox = builtins.readFile ./misc/gruvbox.tmTheme;

    emacs.enable  = true;
    emacs.package = pkgs.unstable.emacs';

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
      shellAliases         = with pkgs.unstable; {
        cat       = "${bat}/bin/bat -p --paging=never";
        less      = "${bat}/bin/bat -p --paging=always";
        ls        = "${lsd'}/bin/lsd --date relative";
        nix-shell = "nix-shell --command fish";
      };
    };

    fzf.defaultOptions  = [ "--color=light" ];
    fzf.enable          = true;

    git = {
      enable      = true;
      extraConfig =
        let delta' = with pkgs.unstable.gitAndTools; ''
              ${delta}/bin/delta --theme "gruvbox" --hunk-style plain \
                --commit-color "#fabd2f" --file-color       "#076678" \
                --minus-color  "#f9d8bc" --minus-emph-color "#fa9f86" \
                --plus-color   "#eeebba" --plus-emph-color  "#d9d87f"
            '';
        in {
          color.ui               = true;
          core.mergeoptions      = "--no-edit";
          core.pager             = delta';
          diff.tool              = "vimdiff";
          fetch.prune            = true;
          interactive.diffFilter = delta';
          merge.conflictstyle    = "diff3";
          merge.tool             = "vimdiff";
          push.default           = "upstream";
        };
      ignores     = [ ".bloop" ".metals" ".idea" "metals.sbt" ];
      userEmail   = "mpkielbowicz@gmail.com";
      userName    = "jupblb";
    };

    htop.enable = true;

    kitty.enable      = true;
    kitty.extraConfig = ''
      ${builtins.readFile ./misc/kitty.conf}
      ${builtins.readFile (pkgs.fetchurl {
        url    = "https://raw.githubusercontent.com/dexpota/kitty-themes/master/themes/gruvbox_light.conf";
        sha256 = "1yvg98vll5yp7nadq2k2q6ri9c9jgk5a5syszbxs7bqpgb27nzha";
      })}
      startup_session ${builtins.toString (pkgs.writeTextFile {	
        name = "kitty-launch";	
        text = "launch fish -C '${pkgs.fortune}/bin/fortune -sa'";	
      })}
    '';

    neovim = {
      configure    = {
        customRC     = ''
          let $PATH .= ':${pkgs.ripgrep}/bin'
          ${builtins.readFile ./misc/init.vim}
        '';
        plug.plugins = with pkgs.unstable.vimPlugins; [
          airline
          denite
          easymotion
          gruvbox-community
          ranger-vim
          vim-devicons vim-nix vim-signify
        ];
      };
      enable       = true;
      vimAlias     = true;
      vimdiffAlias = true;
      withNodeJs   = true;
      withPython   = false;
      withRuby     = false;
    };

    qutebrowser.enable      = true;
    qutebrowser.extraConfig = "config.load_autoconfig()";
    qutebrowser.package     = pkgs.unstable.qutebrowser;

    starship.enable                = true;
    starship.enableFishIntegration = true;
    starship.settings              = {
      add_newline                         = false;
      character.symbol                    = "~>";
      directory.fish_style_pwd_dir_length = 1;
      directory.truncation_length         = 8;
      prompt_order                        = [
        "username" "hostname" "directory" "git_branch" "git_commit" "git_state"
        "git_status" "package" "java" "python" "rust" "nix_shell" "memory_usage"
        "cmd_duration" "character"
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

