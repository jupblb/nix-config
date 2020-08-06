{ config, lib, pkgs, ... }:

{
  home.packages         = with pkgs; ([ ranger screen unzip ] ++ (
    if pkgs.stdenv.isLinux then [ bazel-compdb sway ] else [])
  );
  home.sessionVariables = {
    BAT_THEME            = "gruvbox";
    EDITOR               = "vim";
    MANPAGER             = "vim -c 'set ft=man' -";
    NIXPKGS_ALLOW_UNFREE = "1";
  };
  home.stateVersion     = "20.03";

  nixpkgs.config.packageOverrides =
    let unstable = import <nixpkgs-unstable> {
      overlays = [ (import ./overlays) ];
    };
    in pkgs: {
      bat          = unstable.bat;
      bazel-compdb = unstable.bazel-compdb';
      code-server  = unstable.code-server;
      gitAndTools  = pkgs.gitAndTools // {
        delta = unstable.gitAndTools.delta;
      };
      sd-switch    = unstable.sd-switch;
      sway         = unstable.sway';
      ranger       = unstable.ranger';
      vimPlugins   = unstable.vimPlugins;
      wrapNeovim   = unstable.wrapNeovim;
    };

  programs = {
    # Remember to run `bat cache --build` before first run
    bat.enable         = true;
    bat.themes.gruvbox = builtins.readFile ./misc/gruvbox.tmTheme;

    fish = {
      enable               = true;
      interactiveShellInit = builtins.readFile ./misc/config.fish;
      plugins              = [ {
        name = "bass";
        src  = pkgs.fetchFromGitHub {
          owner  = "edc";
          repo   = "bass";
          rev    = "master";
          sha256 = "0ppmajynpb9l58xbrcnbp41b66g7p0c9l2nlsvyjwk6d16g4p4gy";
        };
      } ];
      shellAliases         = with pkgs; {
        cat       = "${bat}/bin/bat -p --paging=never";
        less      = "${bat}/bin/bat -p --paging=always";
        nix-shell = "nix-shell --command fish";
      };
    };

    fzf.defaultOptions  = [ "--color=light" ];
    fzf.enable          = true;

    git = {
      delta       = {
        enable  = true;
        options = {
          minus-emph-style = "syntax #fa9f86";
          minus-style      = "syntax #f9d8bc";
          plus-emph-style  = "syntax #d9d87f";
          plus-style       = "syntax #eeebba";
          syntax-theme     = "gruvbox";
        };
      };
      enable      = true;
      extraConfig = {
        color.ui          = true;
        core.mergeoptions = "--no-edit";
        fetch.prune       = true;
        push.default      = "upstream";
      };
      ignores     = [ "compile_commands.json" ];
      userName    = "jupblb";
    } // (if pkgs.stdenv.isLinux then {
      userEmail = "mpkielbowicz@gmail.com";
    } else {
      userEmail = "jupblb@google.com";
    });

    htop.enable = true;

    kitty.enable      = true;
    kitty.extraConfig = with pkgs; ''
      ${builtins.readFile ./misc/kitty.conf}
      font_size ${if pkgs.stdenv.isLinux then "10.0" else "14.0"}
      ${builtins.readFile (fetchurl {
        url    = "https://raw.githubusercontent.com/dexpota/kitty-themes/master/themes/gruvbox_light.conf";
        sha256 = "1yvg98vll5yp7nadq2k2q6ri9c9jgk5a5syszbxs7bqpgb27nzha";
      })}
      startup_session ${builtins.toString (writeTextFile {
        name = "kitty-launch";
        text = "launch ${fish}/bin/fish -C '${fortune}/bin/fortune -sa'";
      })}
    '';

    neovim = {
      configure    = {
        customRC            = with pkgs; ''
          let $PATH      .= ':${lib.makeBinPath [
            clang-tools
            metals
            nodePackages.bash-language-server
            python3Packages.python-language-server
            ripgrep
          ]}'
          ${builtins.readFile ./misc/init.vim}
        '';
        plug.plugins        = with pkgs.vimPlugins; [
          completion-nvim
          nvim-lsp
        ];
        packages.nvim.start = with pkgs.vimPlugins; [
          airline
          editorconfig-vim
          gruvbox-community
          fzf-vim
          ranger-vim
          vim-better-whitespace vim-nix vim-signify
        ];
      };
      enable       = true;
      package      = pkgs.neovim-unwrapped.overrideAttrs(old: {
        version = "nightly";
        src     = builtins.fetchGit {
          url = https://github.com/neovim/neovim.git;
          ref = "nightly";
        };
      });
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
  } // (if pkgs.stdenv.isLinux then {
    firefox = {
      enable            = true;
      package           = pkgs.firefox-wayland;
      profiles."jupblb" = {
        extraConfig = builtins.readFile ./misc/firefox/user.js;
        userContent = builtins.readFile ./misc/firefox/user.css;
      };
    };

    i3status.enable        = true;
    i3status.enableDefault = true;

    vscode.enable = true;

    zathura.enable      = true;
    zathura.extraConfig = "set selection-clipboard clipboard";
  } else {});
}

