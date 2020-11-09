{ config, lib, pkgs, ... }:

{
  home.packages         = with pkgs; [
    gitAndTools.git-crypt htop ranger screen unzip
  ];
  home.sessionVariables = { EDITOR = "nvim"; };
  home.username         = "jupblb";

  nixpkgs.config.packageOverrides = pkgs: {
    gitAndTools = pkgs.gitAndTools // {
      delta = pkgs.callPackage ./misc/delta.nix {
        inherit (pkgs.darwin.apple_sdk.frameworks) Security;
      };
    };
    ranger      = pkgs.callPackage ./misc/ranger { ranger = pkgs.ranger; };
  };

  programs = {
    bat = {
      config = { theme = "gruvbox-light"; };
      enable = true;
    };

    fish = {
      enable       = true;
      plugins      = [ {
        name = "bobthefish";
        src  = pkgs.callPackage ./misc/fish/theme-bobthefish.nix {};
      } {
        name = "nix-env";
        src  = pkgs.callPackage ./misc/fish/nix-env.nix {};
      } ];
      promptInit   = builtins.readFile ./misc/fish/prompt.fish;
      shellAliases = {
        cat       = "bat -p --paging=never";
        less      = "bat -p --paging=always";
        nix-shell = "nix-shell --command fish";
        ssh       = "env TERM=xterm-256color ssh";
        vim       = "nvim";
      };
    };

    fzf = {
      enable         = true;
      defaultOptions = [ "--color=light" ];
    };

    git = {
      delta       = {
        enable  = true;
        options = {
          line-numbers            = true;
          line-numbers-zero-style = "#3c3836";
          minus-emph-style        = "syntax #fa9f86";
          minus-style             = "syntax #f9d8bc";
          plus-emph-style         = "syntax #d9d87f";
          plus-style              = "syntax #eeebba";
          side-by-side            = true;
          syntax-theme            = "gruvbox-light";
        };
      };
      enable      = true;
      extraConfig = {
        color.ui          = true;
        core.mergeoptions = "--no-edit";
        fetch.prune       = true;
        pull.rebase       = true;
        push.default      = "upstream";
      };
      signing     = { key = "1F516D495D5D8D5B"; signByDefault = true; };
      userEmail   = "mpkielbowicz@gmail.com";
      userName    = "jupblb";
    };

    gpg.enable = true;

    kitty = {
      enable      = true;
      extraConfig =
        let pkg = pkgs.callPackage ./misc/kitty/kitty-gruvbox-theme.nix {};
        in builtins.readFile("${pkg}/gruvbox_light.conf");
      settings    = {
        font_family         = "PragmataPro Mono Liga";
        font_size           = 10;
        startup_session     = builtins.toString(
          pkgs.callPackage ./misc/kitty/kitty-launch.nix {}
        );
      };
    };

    neovim = {
      extraConfig   = builtins.readFile ./misc/neovim/init.vim;
      plugins       = with pkgs.vimPlugins; [ {
          plugin = lightline-vim;
          config = ''
            set noshowmode
            let g:lightline = { 'colorscheme': 'gruvbox' }
          '';
        } {
          plugin = calendar-vim;
          config = ''
            let google_calendar = "${./misc/neovim/google-calendar.vim}"
            ${builtins.readFile ./misc/neovim/calendar-vim.vim}
          '';
        } {
          plugin = completion-nvim;
          config = builtins.readFile ./misc/neovim/completion-nvim.vim;
        } {
          plugin = pkgs.callPackage ./misc/neovim/glow-nvim.nix {};
          config = "let $GLOW_STYLE = 'light' | nmap <Leader>m :Glow<CR>";
        } {
          plugin = goyo;
          config = "let g:goyo_width = 100 | nmap <silent><Leader>` :Goyo<CR>";
        } {
          plugin = gruvbox-community;
          config = builtins.readFile ./misc/neovim/gruvbox-community.vim;
        } {
          plugin = fzf-vim;
          config = builtins.readFile ./misc/neovim/fzf-vim.vim;
        } {
          plugin = nvim-lspconfig;
          config = builtins.readFile ./misc/neovim/nvim-lspconfig.vim;
        } {
          plugin = nvim-treesitter;
          config = builtins.readFile ./misc/neovim/nvim-treesitter.vim;
        } {
          plugin = pkgs.callPackage ./misc/neovim/nvim-treesitter-context.nix {};
          config = "";
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
        editorconfig-vim vim-signify vim-nix
      ];
      enable        = true;
      extraPackages = with pkgs; [
        glow nodePackages.bash-language-server ripgrep rnix-lsp
      ];
      package       = pkgs.callPackage ./misc/neovim {
        inherit (pkgs.darwin.apple_sdk.frameworks) Security;
      };
      vimAlias      = true;
      vimdiffAlias  = true;
      withPython    = false;
      withPython3   = false;
      withRuby      = false;
    };

    ssh = {
      compression         = true;
      controlMaster       = "auto";
      controlPersist      = "yes";
      enable              = true;
      forwardAgent        = true;
      matchBlocks         =
        let key = {
          identitiesOnly = true;
          identityFile   = [ (builtins.toString ./misc/ssh/id_ed25519) ];
        };
        in {
          "github.com" = key;
          hades        = key // { hostname = "jupblb.ddns.net"; port = 1993; };
          iris         = key // { hostname = "jupblb.ddns.net"; port = 1994; };
        };
      serverAliveInterval = 30;
    };
  };

  xdg.dataFile   = let grammars = pkgs.tree-sitter.builtGrammars; in {
#   "nvim/site/parser/bash.so".source   = "${grammars.bash}/parser";
#   "nvim/site/parser/c.so".source      = "${grammars.c}/parser";
#   "nvim/site/parser/cpp.so".source    = "${grammars.cpp}/parser";
#   "nvim/site/parser/json.so".source   = "${grammars.json}/parser";
#   "nvim/site/parser/lua.so".source    = "${grammars.lua}/parser";
#   "nvim/site/parser/python.so".source = "${grammars.python}/parser";
#   "nvim/site/parser/rust.so".source   = "${grammars.rust}/parser";
  };
  xdg.configFile = {
    "fish/conf.d/plugin-bobthefish.fish".text =
      lib.mkAfter "for f in $plugin_dir/*.fish; source $f; end";
    "hg/hgrc".text                            = ''
      [pager]
      pager = ${pkgs.gitAndTools.delta}/bin/delta
    '';
  };
}

