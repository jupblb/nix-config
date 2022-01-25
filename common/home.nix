{ config, lib, pkgs, ... }:

{
  home = {
    activation.nvim  = lib.hm.dag.entryAfter ["writeBoundary"]
      "$DRY_RUN_CMD nvim --headless +UpdateRemotePlugins +quit && echo";
    file             = { ".ammonite/predef.sc".source = pkgs.ammonite.predef; };
    packages         = with pkgs; [ ammonite git-crypt gore httpie ripgrep zk ];
    sessionVariables = {
      _ZO_FZF_OPTS =
        let preview = "${pkgs.gtree}/bin/gtree -L=2 {2..} | head -200";
        in "$FZF_DEFAULT_OPTS --no-sort --reverse -1 -0 --preview '${preview}'";
      EDITOR       = "nvim";
      GOROOT       = "${pkgs.go}/share/go";
    };
    username         = "jupblb";
  };

  nixpkgs.overlays = [ (import ./overlay) ];

  programs = {
    bash = import ../config/bash;

    bat = {
      config = { theme = "gruvbox-light"; };
      enable = true;
    };

    exa.enable = true;

    firefox = import ../config/firefox.nix;

    fish = {
      enable               = true;
      functions            = {
        fish_greeting =
          "if test $SHLVL -eq 1; ${pkgs.fortune}/bin/fortune -sa; end";
        ls            = builtins.readFile ../config/script/exa.fish;
      };
      plugins              = with pkgs.fishPlugins; [
        { name = "gcloud"; src = gcloud; }
        { name = "gruvbox"; src = gruvbox; }
        { name = "kubectl"; src = kubectl; }
        { name = "nix-env"; src = nix-env; }
      ];
      interactiveShellInit = "theme_gruvbox light hard";
      shellAliases         = with pkgs; {
        cat  = "${bat}/bin/bat -p --paging=never";
        less = "${bat}/bin/bat -p --paging=always";
      };
    };

    fzf = {
      enable                 = true;
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --hidden --type d";
      changeDirWidgetOptions = [
        "--height=100%"
        "--preview '${pkgs.gtree}/bin/gtree -L=2 {} | head -200'"
      ];
      defaultCommand         = "${pkgs.fd}/bin/fd --hidden --type f";
      defaultOptions         = [ "--color=light" ];
      fileWidgetCommand      = "${pkgs.fd}/bin/fd --hidden --type f";
      fileWidgetOptions      = [
        "--height=100%"
        "--preview '${pkgs.bat}/bin/bat --color=always -pp {}'"
      ];
      historyWidgetOptions   = [
        "--height=100%"
        "--preview='echo -- {1..} | fish_indent --ansi'"
        "--preview-window='bottom:9:wrap'"
        "--reverse"
      ];
    };

    git = import ../config/git.nix;

    go = {
      enable = true;
      goPath = "${config.xdg.cacheHome}/go";
    };

    gpg.enable = true;

    htop = {
      enable   = true;
      settings = { hide_threads = true; hide_userland_threads = true; };
    };

    kitty = {
      enable      = true;
      font        = {
        name = "PragmataPro Mono Liga";
        size = 10;
      };
      keybindings = import ../config/kitty/keybindings.nix;
      settings    = (import ../config/kitty/settings.nix) // {
        env   = "SHELL=${pkgs.fish}/bin/fish";
        shell = "${pkgs.fish}/bin/fish";
      };
    };

    lf = {
      enable      = true;
      extraConfig = builtins.readFile ../config/lfrc.sh;
      previewer   = {
        keybinding = "`";
        source     = with pkgs; writeShellScript "lf-preview" ''
          case "$1" in
            *.json)       ${jq}/bin/jq --color-output . "$1";;
            *.md)         ${glow}/bin/glow -s light -- "$1";;
            *.pdf)        ${poppler_utils}/bin/pdftotext "$1" -;;
            *.tar*|*.zip) ${atool}/bin/atool --list -- "$1";;
            *)            ${bat}/bin/bat --style=numbers --color=always "$1";;
          esac
        '';
      };
      settings    = { hidden = true; icons = true; tabstop = 4; };
    };

    mercurial = {
      enable      = true;
      extraConfig = {
        extensions.beautifygraph = "";
        pager.pager              = "${pkgs.gitAndTools.delta}/bin/delta";
      };
      ignores     = [ ".vim-bookmarks" ];
      userEmail   = "mpkielbowicz@gmail.com";
      userName    = "jupblb";
    };

    neovim = {
      extraConfig   = "source ${toString ../config/neovim/init.vim}";
      plugins       = with pkgs.vimPlugins; [ {
          config = "nmap <C-x> :Bdelete!<CR> | nmap <C-S-x> :Bwipeout!<CR>";
          plugin = bufdelete-nvim;
        } {
          config = "source ${toString ../config/neovim/gruvbox-material.vim}";
          plugin = gruvbox-material;
        } {
          config = "source ${toString ../config/neovim/hop.vim}";
          plugin = hop-nvim;
        } {
          config = "luafile ${toString ../config/neovim/lsp-status.lua}";
          plugin = lsp-status-nvim;
        } {
          config = "lua require('lsp_signature').setup({hint_enable = false})";
          plugin = lsp_signature-nvim;
        } {
          config = "luafile ${toString ../config/neovim/lualine.lua}";
          plugin = lualine-nvim;
        } {
          config = "luafile ${toString ../config/neovim/luatab.lua}";
          plugin = luatab-nvim;
        } {
          config = ''
            source ${toString ../config/neovim/neogit.vim}
            luafile ${toString ../config/neovim/neogit.lua}
          '';
          plugin = neogit.overrideAttrs(old: {
            dependencies = old.dependencies ++ [ diffview-nvim ];
          });
        } {
          config = "luafile ${toString ../config/neovim/null-ls.lua}";
          plugin = null-ls-nvim;
        } {
          config = "luafile ${toString ../config/neovim/bqf.lua}";
          plugin = nvim-bqf;
        } {
          config = ''
            set completeopt=menu,menuone,noselect
            luafile ${toString ../config/neovim/cmp.lua}
          '';
          plugin = nvim-cmp.overrideAttrs(_: {
            dependencies = [ cmp-buffer cmp-nvim-lsp cmp-path ];
          });
        } {
          config = "lua require('colorizer').setup({'css','lua','nix','vim'})";
          plugin = nvim-colorizer-lua;
        } {
          config = "luafile ${toString ../config/neovim/jqx.lua}";
          plugin = nvim-jqx;
        } {
          config = ''
            source ${toString ../config/neovim/lspconfig.vim}
            luafile ${toString ../config/neovim/lspconfig.lua}
          '';
          plugin = nvim-lspconfig.overrideAttrs(_: {
            dependencies = [ SchemaStore-nvim ];
          });
        } {
          config = ''
            source ${toString ../config/neovim/metals.vim}
            luafile ${toString ../config/neovim/metals.lua}
          '';
          plugin = nvim-metals;
        } {
          config = "luafile ${toString ../config/neovim/pqf.lua}";
          plugin = nvim-pqf;
        } {
          config = ''
            source ${toString ../config/neovim/tree.vim}
            luafile ${toString ../config/neovim/tree.lua}
          '';
          plugin = nvim-tree-lua;
        } {
          config = ''
            autocmd VimEnter * highlight TSDefinitionUsage guibg=#d9d87f
            luafile ${toString ../config/neovim/treesitter.lua}
          '';
          plugin = nvim-treesitter.overrideAttrs(_: {
            dependencies = [
              nvim-treesitter-refactor nvim-treesitter-textobjects
              nvim-ts-context-commentstring vim-matchup
            ];
          });
        } {
          config = "luafile ${toString ../config/neovim/devicons.lua}";
          plugin = nvim-web-devicons;
        } {
          config = ''
            source ${toString ../config/neovim/telescope.vim}
            luafile ${toString ../config/neovim/telescope.lua}
          '';
          plugin = telescope-nvim.overrideAttrs(old: {
            dependencies = old.dependencies ++ [
              nvim-neoclip-lua telescope-fzf-native-nvim
              telescope-lsp-handlers-nvim telescope-vim-bookmarks-nvim
           ];
          });
        } {
          config = "vmap <C-v><C-v> :VBox<CR>";
          plugin = venn-nvim;
        } {
          config = "source ${toString ../config/neovim/bookmark.vim}";
          plugin = vim-bookmarks;
        } {
          config = "let g:gh_line_blame_map_default = 0";
          plugin = vim-gh-line;
        } {
          config = "source ${toString ../config/neovim/grepper.vim}";
          plugin = vim-grepper;
        } {
          config = "source ${toString ../config/neovim/markdown.vim}";
          plugin = vim-markdown;
        } {
          config = "source ${toString ../config/neovim/mergetool.vim}";
          plugin = vim-mergetool;
        } {
          config = "source ${toString ../config/neovim/signify.vim}";
          plugin = vim-signify;
        } {
          config = "source ${toString ../config/neovim/ultest.vim}";
          plugin = vim-ultest.overrideAttrs(_: {
            dependencies = [ vim-test ];
          });
        }
        commentary git-messenger-vim surround vim-cool vim-sleuth
      ];
      enable        = true;
      extraPackages =
        let
          default      = with pkgs; [
            buildifier cargo coursier fd fish gitlint go-tools gopls jq
            luaformatter openjdk pandoc ripgrep rnix-lsp rust-analyzer rustc
            shellcheck shfmt statix yq-go zk
          ];
          luaPackages  = with pkgs.luaPackages; [ luacheck ];
          nodePackages = with pkgs.nodePackages; [
            bash-language-server dockerfile-language-server-nodejs
            markdownlint-cli pyright vscode-json-languageserver
          ];
        in default ++ luaPackages ++ nodePackages;
      vimAlias      = true;
      vimdiffAlias  = true;
      withNodeJs    = false;
      withPython3   = true;
      withRuby      = false;
    };

    nix-index.enable = true;

    ssh = import ../config/ssh;

    starship = import ../config/starship.nix;

    zoxide = {
      enable  = true;
      options = [ "--cmd cd" ];
    };
  };

  xdg = {
    configFile = {
      "nvim/spell/pl.utf-8.spl".source = pkgs.fetchurl {
        sha256 = "1sg7hnjkvhilvh0sidjw5ciih0vdia9vas8vfrd9vxnk9ij51khl";
        url    = "http://ftp.vim.org/vim/runtime/spell/pl.utf-8.spl";
      };
      "tridactyl/tridactylrc".text     = ''
        ${builtins.readFile ../config/tridactylrc.vim}
        set editorcmd ${pkgs.kitty}/bin/kitty -- ${pkgs.fish}/bin/fish -c "nvim %f"
      '';
      "zk/config.toml".source          =
        let toml = pkgs.formats.toml {}; in toml.generate "config.toml" {
          alias           = {
            edit = "zk edit --interactive $@";
            list = "zk list --interactive $@";
          };
          format.markdown = { link-drop-extension = false; };
          note            = {
            id-charset = "hex";
            id-length  = 8;
            template   = builtins.toString ../config/note-template.md;
          };
          tool            = {
            editor      = "nvim";
            fzf-preview = "${pkgs.glow}/bin/glow --style light {-1}";
          };
        };
    };
    enable     = true;
  };
}
