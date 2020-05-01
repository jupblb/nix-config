{ config, lib, pkgs, ... }:

let
  devPackages = with pkgs.unstable; [
    ammonite' gcc idea-ultimate' neovim' python3 rustup sbt sway'
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
      interactiveShellInit = "set fish_greeting; theme_gruvbox light hard";
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
        ls        = "${pkgs.unstable.lsd'}/bin/lsd --date relative";
        nix-shell = "nix-shell --command fish";
      };
    };

    fzf.defaultOptions  = [ "--color=light" ];
    fzf.enable          = true;

    git = {
      aliases     = {
        bat = "! git diff --name-only --diff-filter=d | xargs ${pkgs.unstable.bat'}/bin/bat --diff";
      };
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

    qutebrowser.enable      = true;
    qutebrowser.extraConfig = "config.load_autoconfig()";

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

