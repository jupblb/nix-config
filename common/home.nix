{ config, lib, pkgs, ... }:

{
  home = {
    file             = {
      ".ammonite/predef.sc".source = pkgs.fetchurl {
        url    = https://git.io/vHaKQ;
        sha256 = "1kir3j5z3drkihx1hysdcmjaiacz840qpwbz70v4k62jr95mz3jp";
      };
    };
    packages         = with pkgs; [
      ammonite gitAndTools.git-crypt gore ripgrep
    ];
    sessionVariables = {
      EDITOR   = "nvim";
      LF_ICONS = "\"${builtins.readFile ../config/lf/lf-icons.cfg}\"";
      GOROOT   = "${pkgs.go}/share/go";
    };
    username         = "jupblb";
  };

  nixpkgs.overlays = [ (import ./overlay) ];

  programs = {
    bat = {
      config = { theme = "gruvbox-light"; };
      enable = true;
    };

    fish = {
      enable       = true;
      plugins      = lib.mapAttrsToList
        (name: pkg: { name = name; src = pkg; }) pkgs.fishPlugins;
      promptInit   = builtins.readFile ../config/prompt.fish;
      shellAliases = {
        cat  = "bat -p --paging=never";
        diff = "delta";
        less = "bat -p --paging=always";
        ll   = "${pkgs.exa}/bin/exa -la --icons";
        ls   = "${pkgs.exa}/bin/exa";
      };
    };

    fzf = {
      enable            = true;
      defaultCommand    = "${pkgs.fd}/bin/fd --hidden --type f";
      defaultOptions    = [ "--color=light" ];
      fileWidgetCommand = "${pkgs.fd}/bin/fd --hidden";
      fileWidgetOptions = [ "--preview 'bat --color=always -pp {}'" ];
    };

    git = {
      aliases     = { amend = "commit -a --amend --no-edit"; };
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

    go = {
      enable = true;
      goPath = ".local/share/go";
    };

    gpg.enable = true;

    htop = {
      enable              = true;
      hideThreads         = true;
      hideUserlandThreads = true;
      showCpuFrequency    = true;
    };

    kitty = {
      enable      = true;
      font        = {
        package = pkgs.pragmata-pro;
        name    = "PragmataPro Mono Liga";
      };
      keybindings = {
        "ctrl+shift+'" = "launch --location=hsplit";
        "ctrl+shift+;" = "launch --location=vsplit";
        "ctrl+shift+`" = "show_scrollback";
        "ctrl+shift+h" = "move_window left";
        "ctrl+shift+j" = "move_window bottom";
        "ctrl+shift+k" = "move_window top";
        "ctrl+shift+l" = "move_window right";
        "ctrl+h"       = "neighboring_window left";
        "ctrl+j"       = "neighboring_window bottom";
        "ctrl+k"       = "neighboring_window top";
        "ctrl+l"       = "neighboring_window right";
      };
      settings    = {
        background                    = "#f9f5d7";
        clipboard_control             =
          "write-clipboard write-primary no-append";
        enabled_layouts               = "splits";
        enable_audio_bell             = "no";
        font_size                     = 10;
        foreground                    = "#282828";
        scrollback_pager              =
          "nvim -c 'setl ft=man | call clearmatches() | autocmd VimEnter * norm G{}'";
        scrollback_pager_history_size = 4096;
        shell                         = "${pkgs.fish}/bin/fish";
      };
    };

    lf = {
      enable      = true;
      extraConfig = builtins.readFile ../config/lf/lfrc.sh;
      previewer   = { keybinding = "`"; source = pkgs.lf-previewer; };
      settings    = { hidden = true; icons = true; tabstop = 4; };
    };

    mercurial = {
      enable      = true;
      extraConfig = { pager.pager = "${pkgs.gitAndTools.delta}/bin/delta"; };
      userEmail   = "mpkielbowicz@gmail.com";
      userName    = "jupblb";
    };

    neovim = {
      extraConfig   = builtins.readFile ../config/neovim/init.vim;
      plugins       = with pkgs.vimPlugins; [ {
          plugin = glow-nvim;
          config = "let $GLOW_STYLE = 'light' | nmap <Leader>m :Glow<CR>";
        } {
          plugin = gruvbox-nvim;
          config = builtins.readFile ../config/neovim/gruvbox.vim;
        } {
          plugin = lf-vim;
          config = builtins.readFile ../config/neovim/lf.vim;
        } {
          plugin = lualine-nvim;
          config = "luafile ${../config/neovim/lualine.lua}";
        } {
          plugin = nvim-lspconfig.overrideAttrs(_: {
            dependencies = [ completion-nvim ];
          });
          config = "luafile ${../config/neovim/lspconfig.lua}";
        } {
          plugin = nvim-tree-lua;
          config = builtins.readFile ../config/neovim/nvim-tree.vim;
        } {
          plugin = nvim-treesitter.overrideAttrs(_: {
            dependencies = [ nvim-treesitter-refactor ];
          });
          config = builtins.readFile ../config/neovim/treesitter.vim;
        } {
          plugin = telescope-nvim.overrideAttrs(old: {
            dependencies = old.dependencies ++ [ telescope-fzy-native-nvim ];
          });
          config = "luafile ${../config/neovim/telescope.lua}";
        } {
          plugin = vimwiki;
          config = ''
            let g:vimwiki_list = [{'path': '~/Documents/vimwiki/',
                \ 'syntax': 'markdown', 'ext': '.md'}]
          '';
        }
        commentary fugitive nvim-web-devicons vim-fish vim-go vim-jsonnet
          vim-signify
      ];
      enable        = true;
      extraPackages =
        let
          packages        = with pkgs; [
            fd gcc glow gopls metals ripgrep rnix-lsp tree-sitter
          ];
          nodePackages    = with pkgs.nodePackages; [
            bash-language-server
            npm
            typescript-language-server
            vim-language-server vscode-css-languageserver-bin
              vscode-html-languageserver-bin vscode-json-languageserver-bin
            yaml-language-server
          ];
        in packages ++ nodePackages;
      package       = pkgs.neovim-nightly;
      vimAlias      = true;
      vimdiffAlias  = true;
      withNodeJs    = true;
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
          identityFile   = [ (toString ../config/ssh/id_ed25519) ];
        };
        in {
          dionysus     = key // { hostname = "jupblb.ddns.net"; port = 1995; };
          "github.com" = key;
          hades        = key // { hostname = "jupblb.ddns.net"; port = 1993; };
        };
      serverAliveInterval = 30;
    };
  };
}
