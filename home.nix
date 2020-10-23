{ config, lib, pkgs, ... }:

{
  home.packages         = with pkgs; [ htop ranger screen unzip ];
  home.sessionVariables = { EDITOR = "nvim"; };
  home.username         = "jupblb";

  nixpkgs.config.packageOverrides = pkgs: {
    ranger = pkgs.callPackage ./misc/ranger { ranger = pkgs.ranger; };
  };

  programs = {
    bat.enable = true;
    bat.config = { theme = "gruvbox-light"; };

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
        src  = pkgs.fetchFromGitHub {
          owner  = "oh-my-fish";
          repo   = "theme-bobthefish";
          rev    = "a2ad38aa051aaed25ae3bd6129986e7f27d42d7b";
          sha256 = "1fssb5bqd2d7856gsylf93d28n3rw4rlqkhbg120j5ng27c7v7lq";
        };
      } ];
      shellAliases         = {
        cat       = "bat -p --paging=never";
        less      = "bat -p --paging=always";
        nix-shell = "nix-shell --command fish";
        ssh       = "kitty +kitten ssh";
      };
    };

    fzf.enable         = true;
    fzf.defaultOptions = [ "--color=light" ];

    git = {
      delta       = {
        enable  = true;
        options = {
          line-numbers            = true;
          line-numbers-zero-style = "#3c3836";
          minus-emph-style        = "syntax bold #fa9f86";
          minus-style             = "syntax bold #f9d8bc";
          plus-emph-style         = "syntax bold #d9d87f";
          plus-style              = "syntax bold #eeebba";
          side-by-side            = true;
          syntax-theme            = "Solarized (light)";
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

    kitty = {
      enable      = true;
      extraConfig = builtins.readFile(pkgs.fetchurl {
        url    = "https://raw.githubusercontent.com/dexpota/kitty-themes/master/themes/gruvbox_light.conf";
        sha256 = "1yvg98vll5yp7nadq2k2q6ri9c9jgk5a5syszbxs7bqpgb27nzha";
      });
      settings    = {
        font_family         = "PragmataPro Mono Liga";
        font_size           = if pkgs.stdenv.isLinux then 10 else 14;
        macos_option_as_alt = "yes";
        startup_session     = builtins.toString(pkgs.writeTextFile {
          name = "kitty-launch";
          text = "launch fish -C '${pkgs.fortune}/bin/fortune -sa'";
        });
      };
    };

    neovim = {
      extraConfig   = ''
        packadd completion-nvim
        packadd nvim-lspconfig
        ${builtins.readFile ./misc/nvim/init.vim}
      '';
      plugins       = with pkgs.vimPlugins; [ {
          plugin = lightline-vim;
          config = ''
            set noshowmode
            let g:lightline = { 'colorscheme': 'gruvbox' }
          '';
        } {
          plugin = calendar-vim;
          config = builtins.readFile ./misc/nvim/calendar-vim.vim;
        } {
          plugin = completion-nvim;
          config = builtins.readFile ./misc/nvim/completion-nvim.vim;
        } {
          plugin = goyo;
          config = ''
            let g:goyo_width = 100
            nmap <silent><Leader>` :Goyo<CR>
          '';
        } {
          plugin = gruvbox-community;
          config = builtins.readFile ./misc/nvim/gruvbox-community.vim;
        } {
          plugin = fzf-vim;
          config = builtins.readFile ./misc/nvim/fzf-vim.vim;
        } {
          plugin = nvim-lspconfig;
          config = builtins.readFile ./misc/nvim/nvim-lspconfig.vim;
        } {
          plugin = ranger-vim;
          config = "nnoremap <Leader><CR> :RangerEdit<CR>";
        } {
          plugin = vimwiki;
          config = ''
            let g:vimwiki_list = [{'path': '~/Documents/vimwiki/',
                \ 'syntax': 'markdown', 'ext': '.md'}]
          '';
        }
        editorconfig-vim vim-better-whitespace vim-polyglot vim-signify
      ];
      enable        = true;
      extraPackages = with pkgs; [
        nodePackages.bash-language-server ripgrep rnix-lsp
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

  xdg.configFile."fish/conf.d/plugin-bobthefish.fish".text =
    lib.mkAfter "for f in $plugin_dir/*.fish; source $f; end";
}

