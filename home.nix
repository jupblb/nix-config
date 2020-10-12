{ config, lib, pkgs, ... }:

{
  home.file             = {
    ".emacs.d/init.el".text            = ''(load "default.el")'';
    "Applications/home-manager".source =
      let apps = pkgs.buildEnv {
        name        = "home-manager-applications";
        paths       = config.home.packages;
        pathsToLink = "/Applications";
      };
      in lib.mkIf pkgs.stdenv.isDarwin "${apps}/Applications";
  };
  home.packages         = with pkgs; [ ranger screen unzip ];
  home.sessionVariables = {
    MANPAGER             = "vim -c 'set ft=man' -";
    NIXPKGS_ALLOW_UNFREE = "1";
  };
  home.username         = "jupblb";

  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    ranger = callPackage ./misc/ranger { ranger = pkgs.ranger; };
  };

  programs = {
    # Remember to run `bat cache --build` before first run
    bat.enable         = true;
    bat.themes.gruvbox = builtins.readFile ./misc/gruvbox.tmTheme;

    emacs.enable        = true;
    emacs.extraPackages = epkgs: with epkgs; [
      doom-modeline
      evil evil-collection
      gruvbox-theme
      org
      use-package
      which-key

      (pkgs.runCommand "default.el" {} ''
        mkdir -p $out/share/emacs/site-lisp
        cp ${./misc/init.el} $out/share/emacs/site-lisp/default.el
      '')
    ];

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

    htop.enable = true;

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
      configure    = {
        customRC            = let
          regular = with pkgs; [ ripgrep rnix-lsp ];
          node    = with pkgs.nodePackages; [ bash-language-server ];
                              in ''
            let $PATH      .= ':${lib.makeBinPath (regular ++ node)}'
            ${builtins.readFile ./misc/init.vim}
          '';
        plug.plugins        = with pkgs.vimPlugins; [
          completion-nvim nvim-lspconfig
        ];
        packages.nvim.start = with pkgs.vimPlugins; [
          airline
          editorconfig-vim
          gruvbox-community
          fzf-vim
          ranger-vim
          vim-better-whitespace vim-jsonnet vim-nix vim-signify
        ];
      };
      enable       = true;
      package      = pkgs.neovim-unwrapped.overrideAttrs(old: {
        version = "nightly";
        src     = pkgs.fetchFromGitHub {
          owner  = "neovim";
          repo   = "neovim";
          rev    = "nightly";
          sha256 = "0mvxksccxh593x513br2pxx93f66m1fdc616pv5f0zwyplr8ir5x";
        };
      });
      vimAlias     = true;
      vimdiffAlias = true;
      withNodeJs   = false;
      withPython   = false;
      withPython3  = false;
      withRuby     = false;
    };
  };

  xdg.configFile."fish/conf.d/plugin-bobthefish.fish".text = lib.mkAfter ''
    for f in $plugin_dir/*.fish
      source $f
    end
  '';
}

