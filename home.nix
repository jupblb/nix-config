{ config, lib, pkgs, ... }:

{
  home.packages         = with pkgs; [ ranger screen unzip ];
  home.sessionVariables = {
    MANPAGER             = "vim -c 'set ft=man' -";
    NIXPKGS_ALLOW_UNFREE = "1";
  };
  home.username         = "jupblb";

  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    glow   = writeScriptBin "glow" "${glow}/bin/glow -s light $@";
    ranger = callPackage ./misc/ranger { ranger = pkgs.ranger; };
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
      } {
        name = "bobthefish";
        src = pkgs.fetchFromGitHub {
          owner  = "oh-my-fish";
          repo   = "theme-bobthefish";
          rev    = "a2ad38aa051aaed25ae3bd6129986e7f27d42d7b";
          sha256 = "1fssb5bqd2d7856gsylf93d28n3rw4rlqkhbg120j5ng27c7v7lq";
        };
      } ];
    };

    fzf.enable = true;

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
      userEmail   = "mpkielbowicz@gmail.com";
      userName    = "jupblb";
    };

    htop.enable  = true;
    htop.vimMode = true;

    kitty.enable      = true;
    kitty.extraConfig = with pkgs; ''
      ${builtins.readFile ./misc/kitty.conf}
      ${lib.optionalString stdenv.isLinux "font_size 10.0"}
      ${lib.optionalString stdenv.isDarwin "font_size 14.0"}
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
      configure     = {
        customRC            = builtins.readFile ./misc/init.vim;
        plug.plugins        = with pkgs.vimPlugins; [
          completion-nvim nvim-lspconfig
        ];
        packages.nvim.start =
          let glow-nvim = pkgs.vimUtils.buildVimPlugin {
            pname   = "glow-nvim";
            version = "2020-10-12";
            src     = pkgs.fetchFromGitHub {
              owner  = "npxbr";
              repo   = "glow.nvim";
              rev    = "master";
              sha256 = "0qkvxly52qdxw77mlrwzrjp8i6smzmsd6k4pd7qqq2w8s8y8rda3";
            };
          };
          in with pkgs.vimPlugins; [
            airline
            editorconfig-vim
            glow-nvim goyo gruvbox-community
            fzf-vim
            ranger-vim
            vim-better-whitespace vim-jsonnet vim-markdown vim-nix vim-signify
          ];
      };
      enable        = true;
      extraPackages = with pkgs; [
        glow nodePackages.bash-language-server ripgrep rnix-lsp
      ];
      package       = pkgs.neovim-unwrapped.overrideAttrs(old: {
        version = "nightly";
        src     = pkgs.fetchFromGitHub {
          owner  = "neovim";
          repo   = "neovim";
          rev    = "nightly";
          sha256 = "0z56xv5bmjq8ivkrpvfgbhnq8vxvbr7231ldg7bipf273widw55m";
        };
      });
      vimAlias      = true;
      vimdiffAlias  = true;
      withNodeJs    = false;
      withPython    = false;
      withPython3   = false;
      withRuby      = false;
    };
  };

  xdg.configFile."fish/conf.d/plugin-bobthefish.fish".text = lib.mkAfter ''
    for f in $plugin_dir/*.fish; source $f; end
  '';
}

