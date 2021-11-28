{ config, lib, pkgs, ... }:

{
  home = {
    activation.nvim  = lib.hm.dag.entryAfter ["writeBoundary"]
      "$DRY_RUN_CMD nvim --headless +UpdateRemotePlugins +quit && echo";
    file             = { ".ammonite/predef.sc".source = pkgs.ammonite.predef; };
    packages         = with pkgs; [ ammonite git-crypt gore ripgrep zk ];
    sessionVariables = { EDITOR = "nvim"; GOROOT = "${pkgs.go}/share/go"; };
    username         = "jupblb";
  };

  nixpkgs.config.allowUnfreePredicate = pkg: (lib.getName pkg) == "tabnine";
  nixpkgs.overlays                    = [ (import ./overlay) ];

  programs = {
    bash = {
      enable         = true;
      historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
      shellOptions   = [ "cdspell" "checkwinsize" "cmdhist" "histappend" ];
      initExtra      = builtins.readFile ../config/bashrc;
    };

    bat = {
      config = { theme = "gruvbox-light"; };
      enable = true;
    };

    exa.enable = true;

    fish = {
      enable               = true;
      functions            = {
        fish_greeting =
          "if test $SHLVL -eq 1; ${pkgs.fortune}/bin/fortune -sa; end";
        lfcd          = "${builtins.readFile pkgs.lf.lfcd-fish} lfcd $argv";
        ls            = builtins.readFile ../config/script/exa.fish;
      };
      plugins              = with pkgs.fishPlugins; [
        { name = "gcloud"; src = gcloud; }
        { name = "gruvbox"; src = gruvbox; }
        { name = "kubectl"; src = kubectl; }
        { name = "nix-env"; src = nix-env; }
      ];
      interactiveShellInit = ''
        set -gx LF_ICONS "${builtins.readFile ../config/lf/lf-icons.cfg}"
        theme_gruvbox light hard
      '';
      shellAliases         = {
        cat  = "bat -p --paging=never";
        less = "bat -p --paging=always";
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
      aliases     = {
        amend = "commit -a --amend --no-edit";
        line  = "!sh -c 'git log -L$2,+1:\${GIT_PREFIX:-./}$1' -";
        lines = "!sh -c 'git log -L$2,$3:\${GIT_PREFIX:-./}$1' -";
      };
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
        color.ui            = true;
        core.mergeoptions   = "--no-edit";
        fetch.prune         = true;
        merge.conflictStyle = "diff3";
        pull.rebase         = true;
        push.default        = "upstream";
        submodule.recurse   = true;
      };
      ignores     = [ ".vim-bookmarks" ];
      signing     = { key = "1F516D495D5D8D5B"; signByDefault = true; };
      userEmail   = "mpkielbowicz@gmail.com";
      userName    = "jupblb";
    };

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
        name    = "PragmataPro Mono Liga";
        package = pkgs.pragmata-pro;
        size    = 10;
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
        foreground                    = "#282828";
        scrollback_pager              =
          "nvim -c 'call clearmatches() | Man! | set syntax=off | autocmd VimEnter * norm G{}'";
        scrollback_pager_history_size = 4096;
        shell                         = "${pkgs.fish}/bin/fish";
      };
    };

    lf = {
      enable      = true;
      extraConfig = builtins.readFile ../config/lf/lfrc.sh;
      previewer   = { keybinding = "`"; source = pkgs.lf.previewer; };
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
          plugin = lualine-nvim.overrideAttrs(_: {
            dependencies = [ vim-sleuth ];
          });
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
          config = "luafile ${toString ../config/neovim/bqf.lua}";
          plugin = nvim-bqf;
        } {
          config = ''
            set completeopt=menu,menuone,noselect
            luafile ${toString ../config/neovim/cmp.lua}
          '';
          plugin = nvim-cmp.overrideAttrs(_: {
            dependencies = [ cmp-buffer cmp-nvim-lsp cmp-path cmp-tabnine ];
          });
        } {
          config = "lua require('colorizer').setup()";
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
            dependencies = [ null-ls-nvim schemastore ];
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
          plugin =
            let nvim-treesitter' =
              nvim-treesitter.withPlugins(_: pkgs.tree-sitter.allGrammars);
            in nvim-treesitter'.overrideAttrs(_: {
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
              neoclip telescope-fzf-native-nvim telescope-lsp-handlers
              telescope-vim-bookmarks
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
        commentary git-messenger-vim surround vim-cool
      ];
      enable        = true;
      extraPackages =
        let
          default      = with pkgs; [
            coursier fd fish google-java-format gopls jq jsonnet-language-server
            luaformatter openjdk pandoc ripgrep rnix-lsp shellcheck shfmt
            tabnine yq-go zk
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

    ssh = {
      compression         = true;
      controlMaster       = "auto";
      controlPersist      = "yes";
      enable              = true;
      forwardAgent        = true;
      matchBlocks         =
        let config = {
          hostname       = "jupblb.ddns.net";
          identitiesOnly = true;
          identityFile   = [ (toString ../config/ssh/id_ed25519) ];
        };
        in {
          dionysus     = config // { port = 1995; };
          "github.com" = config // { hostname = "github.com"; };
          hades        = config // { port = 1993; };
        };
      serverAliveInterval = 30;
    };

    starship = {
      enable   = true;
      settings = {
        add_newline = false;
        directory   = {
          read_only         = " ";
          truncation_length = 8;
          truncation_symbol = "…/";
        };
        format      =
          let
            git    = map (s: "git_" + s) [ "branch" "commit" "state" "status" ];
            line   = prefix ++ [ "hg_branch" ] ++ git  ++ [ "status" "shell" ];
            prefix = [ "shlvl" "nix_shell"  "hostname" "directory" ];
          in lib.concatMapStrings (e: "$" + e) line;
        git_branch  = { symbol = " "; };
        git_status  = {
          ahead      = " ";
          behind     = " ";
          conflicted = " ";
          deleted    = " ";
          diverged   = " ";
          format     =
            "([$all_status](underline $style)[$ahead_behind]($style) )";
          modified   = " ";
          renamed    = " ";
          staged     = " ";
          stashed    = " ";
          untracked  = " ";
        };
        hg_branch   = { disabled = false; symbol = " "; };
        hostname    = { format = "[($hostname:)]($style)"; };
        nix_shell   = { format = "[ ]($style) "; };
        shell       = {
          bash_indicator = "\\$";
          disabled       = false;
          fish_indicator = "~>";
        };
        shlvl       = { disabled = false; symbol = " "; };
        status      = { disabled = false; symbol = " "; };
      };
    };

    zoxide = {
      enable  = true;
      options = [ "--cmd cd" ];
    };
  };

  xdg = {
    configFile = {
      "nvim/spell/pl.utf-8.spl".source = builtins.fetchurl
        "http://ftp.vim.org/vim/runtime/spell/pl.utf-8.spl";
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
