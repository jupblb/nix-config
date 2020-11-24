{ config, lib, pkgs, ... }:

{
  home.packages         = with pkgs; [ bottom gitAndTools.git-crypt ];
  home.sessionVariables = { EDITOR = "nvim"; };
  home.username         = "jupblb";

  nixpkgs.overlays = [ (import ./overlay) ];

  programs = {
    bat = {
      config = { theme = "gruvbox-light"; };
      enable = true;
    };

    firefox = {
      enable            = true;
      profiles."jupblb" = {
        extraConfig = builtins.readFile ../config/firefox/user.js;
        userContent = builtins.readFile ../config/firefox/user.css;
      };
    };

    fish = {
      enable               = true;
      interactiveShellInit = "theme_gruvbox light hard";
      plugins              = lib.mapAttrsToList
        (name: pkg: { name = name; src = pkg; }) pkgs.fishPlugins;
      promptInit           = builtins.readFile ../config/prompt.fish;
      shellAliases         = {
        cat  = "bat -p --paging=never";
        less = "bat -p --paging=always";
        ls   = "ls --color=auto --group-directories-first";
        ssh  = "env TERM=xterm-256color ssh";
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
      enable   = true;
      settings = {
        clipboard_control   = "write-clipboard write-primary no-append";
        font_family         = "PragmataPro Mono Liga";
        font_size           = 10;
        startup_session     = toString(pkgs.writeText "kitty-launch" ''
          launch fish -C "tmux && exit";
        '');
      };
    };

    lf = {
      enable           = true;
      previewer.source = with pkgs; writeShellScript "lf-preview" ''
        case "$1" in
          *.json) ${jq}/bin/jq --color-output . "$1";;
          *.md)   ${glow}/bin/glow -s light - "$1";;
          *.pdf)  ${poppler_utils}/bin/pdftotext "$1" -;;
          *)      ${bat}/bin/bat -p --color always "$1";;
        esac
      '';
      settings         = { hidden = true; tabstop = 4; };
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
          plugin = lightline-vim;
          config = ''
            set noshowmode
            let g:lightline = { 'colorscheme': 'gruvbox' }
          '';
        } {
          plugin = calendar-vim;
          config = ''
            let google_calendar = "${../config/neovim/google-calendar.vim}"
            ${builtins.readFile ../config/neovim/calendar-vim.vim}
          '';
        } {
          plugin = completion-nvim;
          config = builtins.readFile ../config/neovim/completion-nvim.vim;
        } {
          plugin = glow;
          config = "let $GLOW_STYLE = 'light' | nmap <Leader>m :Glow<CR>";
        } {
          plugin = gruvbox-community;
          config = builtins.readFile ../config/neovim/gruvbox-community.vim;
        } {
          plugin = fzf-vim;
          config = builtins.readFile ../config/neovim/fzf-vim.vim;
        } {
          plugin = lf-vim;
          config = builtins.readFile ../config/neovim/lf.vim;
        } {
          plugin = nvim-lspconfig;
          config = builtins.readFile ../config/neovim/nvim-lspconfig.vim;
        } {
          plugin = nvim-treesitter;
          config = builtins.readFile ../config/neovim/nvim-treesitter.vim;
        } {
          plugin = vimwiki;
          config = ''
            let g:vimwiki_list = [{'path': '~/Documents/vimwiki/',
                \ 'syntax': 'markdown', 'ext': '.md'}]
          '';
        }
        editorconfig-vim treesitter-context vim-fish vim-signify vim-nix
          vim-tmux-navigator
      ];
      enable        = true;
      extraPackages = with pkgs; [
        glow nodePackages.bash-language-server ripgrep rnix-lsp
      ];
      package       = pkgs.neovim-nightly;
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
          identityFile   = [ (toString ../config/ssh/id_ed25519) ];
        };
        in {
          "github.com" = key;
          hades        = key // { hostname = "jupblb.ddns.net"; port = 1993; };
          iris         = key // { hostname = "jupblb.ddns.net"; port = 1994; };
        };
      serverAliveInterval = 30;
    };

    tmux = {
      baseIndex                 = 1;
      disableConfirmationPrompt = true;
      enable                    = true;
      extraConfig               = builtins.readFile ../config/tmux.conf;
      keyMode                   = "vi";
      plugins                   = with pkgs.tmuxPlugins; [
        pain-control vim-tmux-navigator yank
      ];
      shortcut                  = "Space";
      terminal                  = "tmux-256color";
    };
  };

  xdg.dataFile   =
    let
      link  = lang: lib.nameValuePair
        "nvim/site/parser/${lang}.so"
        "${pkgs.tree-sitter.builtGrammars."${lang}"}/parser";
      langs = [ "bash" "c" "cpp" "go" "html" "java" "json" "lua" "python" ];
    in lib.mapAttrs (_: g: { source = g; }) (lib.listToAttrs (map link langs));
}
