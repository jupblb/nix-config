{ config, lib, pkgs, ... }:

{
  home.packages         = with pkgs; [
    gitAndTools.git-crypt htop ranger screen unzip
  ];
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
        extraConfig = builtins.readFile ./config/firefox/user.js;
        userContent = builtins.readFile ./config/firefox/user.css;
      };
    };

    fish = {
      enable       = true;
      plugins      = [
        { name = "bobthefish"; src = pkgs.fishPlugins.theme-bobthefish; }
        { name = "nix-env"; src = pkgs.fishPlugins.nix-env; }
      ];
      promptInit   = builtins.readFile ./config/prompt.fish;
      shellAliases = {
        cat       = "bat -p --paging=never";
        less      = "bat -p --paging=always";
        ls        = "ls --color=auto --group-directories-first";
        nix-shell = "nix-shell --command fish";
        ssh       = "env TERM=xterm-256color ssh";
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
        let pkg = pkgs.fetchFromGitHub {
          owner  = "wdomitrz";
          repo   = "kitty-gruvbox-theme";
          rev    = "master";
          sha256 = "0s1jbmw3xzzg00lxkxk4ryhhyxck5an7nmrq5cy9vdp1f1a0lgrr";
        };
        in builtins.readFile "${pkg}/gruvbox_light.conf";
      settings    = {
        font_family         = "PragmataPro Mono Liga";
        font_size           = 10;
        startup_session     = toString(pkgs.writeTextFile {
          name = "kitty-launch";
          text = "launch fish -C '${pkgs.fortune}/bin/fortune -sa'";
        });
      };
    };

    neovim = {
      extraConfig   = builtins.readFile ./config/neovim/init.vim;
      plugins       = with pkgs.vimPlugins; [ {
          plugin = lightline-vim;
          config = ''
            set noshowmode
            let g:lightline = { 'colorscheme': 'gruvbox' }
          '';
        } {
          plugin = calendar-vim;
          config = ''
            let google_calendar = "${./config/neovim/google-calendar.vim}"
            ${builtins.readFile ./config/neovim/calendar-vim.vim}
          '';
        } {
          plugin = completion-nvim;
          config = builtins.readFile ./config/neovim/completion-nvim.vim;
        } {
          plugin = glow;
          config = "let $GLOW_STYLE = 'light' | nmap <Leader>m :Glow<CR>";
        } {
          plugin = goyo;
          config = "let g:goyo_width = 100 | nmap <silent><Leader>` :Goyo<CR>";
        } {
          plugin = gruvbox-community;
          config = builtins.readFile ./config/neovim/gruvbox-community.vim;
        } {
          plugin = fzf-vim;
          config = builtins.readFile ./config/neovim/fzf-vim.vim;
        } {
          plugin = nvim-lspconfig;
          config = builtins.readFile ./config/neovim/nvim-lspconfig.vim;
        } {
          plugin = nvim-treesitter;
          config = builtins.readFile ./config/neovim/nvim-treesitter.vim;
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
        editorconfig-vim treesitter-context vim-fish vim-signify vim-nix
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
          identityFile   = [ (toString ./config/ssh/id_ed25519) ];
        };
        in {
          "github.com" = key;
          hades        = key // { hostname = "jupblb.ddns.net"; port = 1993; };
          iris         = key // { hostname = "jupblb.ddns.net"; port = 1994; };
        };
      serverAliveInterval = 30;
    };
  };

  xdg.dataFile   =
    let
      link  = lang: lib.nameValuePair
        "nvim/site/parser/${lang}.so"
        "${pkgs.tree-sitter.builtGrammars."${lang}"}/parser";
      langs = [ "bash" "c" "cpp" "go" "html" "java" "json" "lua" "python" ];
    in lib.mapAttrs (_: g: { source = g; }) (lib.listToAttrs (map link langs));
  xdg.configFile = {
    "fish/conf.d/plugin-bobthefish.fish".text =
      lib.mkAfter "for f in $plugin_dir/*.fish; source $f; end";
    ".hgrc".text                              = ''
      [pager]
      pager = ${pkgs.gitAndTools.delta}/bin/delta
    '';
  };
}

