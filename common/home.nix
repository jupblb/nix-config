{ config, lib, pkgs, ... }:

{
  home = {
    activation       = {
      bat  = lib.hm.dag.entryAfter ["writeBoundary"]
        "$DRY_RUN_CMD ${pkgs.bat}/bin/bat cache --build";
      nvim = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD nvim --headless \
          +UpdateRemotePlugins +TSUpdateSync all +quit && echo
      '';
    };
    packages         = with pkgs;
      [ ammonite curlie forgit git-crypt gore ripgrep tldr telescope zk ];
    sessionVariables = {
      _ZO_FZF_OPTS =
        let preview = "${pkgs.gtree}/bin/gtree -L=2 {2..} | head -200";
        in "$FZF_DEFAULT_OPTS --no-sort --reverse -1 -0 --preview '${preview}'";
      EDITOR       = "nvim";
      GOROOT       = "${pkgs.go}/share/go";
    };
    shellAliases     = { icat = "kitty +kitten icat"; };
    username         = "jupblb";
  };

  nixpkgs.overlays = [ (import ./overlay) ];

  programs = {
    bash = {
      enable         = true;
      historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
      shellAliases   = { "ls" = "ls --color=auto"; };
      shellOptions   = [ "cdspell" "checkwinsize" "cmdhist" "histappend" ];
      initExtra      = "source ${toString ../config/bashrc.bash}";
    };

    direnv = {
      config     = {
        bash_path     = "${pkgs.bashInteractive}/bin/bash";
        disable_stdin = true;
        strict_env    = true;
      };
      enable     = true;
      nix-direnv = { enable = true; };
    };

    exa.enable = true;

    firefox = {
      enable                        = true;
      profiles."jupblb".settings    = {
        "browser.aboutConfig.showWarning"          = false;
        "browser.toolbars.bookmarks.visibility"    = "never";
        "extensions.pocket.enabled"                = false;
        "full-screen-api.warning.timeout"          = 0;
        "network.protocol-handler.expose.magnet"   = false;
        "permissions.default.desktop-notification" = 2;
      };
    };


    fish = {
      enable               = true;
      functions            = {
        delta-view    = {
          body     = builtins.readFile ../config/script/delta-view.fish;
          onSignal = "WINCH";
        };
        fish_greeting =
          "if test $SHLVL -eq 1; ${pkgs.fortune}/bin/fortune -sa; end";
        ls            = builtins.readFile ../config/script/exa.fish;
      };
      interactiveShellInit = "delta-view";
      shellAliases         = with pkgs; {
        cat  = "${bat}/bin/bat -p --paging=never";
        diff = "${difftastic}/bin/difft --background=light";
        less = "${bat}/bin/bat -p --paging=always";
      };
    };

    fzf = {
      enable                 = true;
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --hidden --type d";
      changeDirWidgetOptions = [
        "--preview '${pkgs.gtree}/bin/gtree -L=2 {} | head -200'"
      ];
      defaultCommand         = "${pkgs.fd}/bin/fd --hidden --type f";
      defaultOptions         = [ "--color=light" ];
      fileWidgetCommand      = "${pkgs.fd}/bin/fd --hidden --type f";
      fileWidgetOptions      = [
        "--preview '${pkgs.bat}/bin/bat --color=always -pp {}'"
      ];
      historyWidgetOptions   = [
        "--bind ctrl-e:preview-down,ctrl-y:preview-up"
        "--preview='echo -- {1..} | fish_indent --ansi'"
        "--preview-window='bottom:3:wrap'"
        "--reverse"
      ];
    };

    git = {
      aliases     = {
        amend = "commit --amend --no-edit";
        line  = "!sh -c 'git log -L$2,+1:\${GIT_PREFIX:-./}$1' -";
        lines = "!sh -c 'git log -L$2,$3:\${GIT_PREFIX:-./}$1' -";
      };
      delta       = {
        enable  = true;
        options = {
          line-numbers            = true;
          minus-emph-style        = "syntax #fa9f86";
          minus-style             = "syntax #f9d8bc";
          plus-emph-style         = "syntax #d9d87f";
          plus-style              = "syntax #eeebba";
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
      iniContent  = {
        core.pager =
          lib.mkForce "sh -c 'delta --width \${FZF_PREVIEW_COLUMNS-$COLUMNS}'";
      };
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
      environment = { BAT_THEME = "gruvbox-light"; };
      font        = {
        name = "PragmataPro Mono Liga";
        size = 10;
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
        allow_remote_control               = "yes";
        clipboard_control                  =
          "write-clipboard write-primary no-append";
        enabled_layouts                    = "splits";
        enable_audio_bell                  = "no";
        env                                = "SHELL=${pkgs.fish}/bin/fish";
        listen_on                          = "unix:/tmp/kitty";
        macos_option_as_alt                = "left";
        macos_quit_when_last_window_closed = "yes";
        scrollback_pager                   =
          "kitty @ launch --type=overlay --stdin-source=@screen_scrollback nvim -R -c 'autocmd VimEnter * norm G{}' -";
        scrollback_pager_history_size      = 4096;
        shell                              = "${pkgs.fish}/bin/fish";
        symbol_map                         =
          let mappings = [
            "U+23FB-U+23FE" "U+2B58" "U+E200-U+E2A9" "U+E0A0-U+E0A3" "U+E0B0-U+E0BF"
            "U+E0C0-U+E0C8" "U+E0CC-U+E0CF" "U+E0D0-U+E0D2" "U+E0D4" "U+E700-U+E7C5"
            "U+F000-U+F2E0" "U+2665" "U+26A1" "U+F400-U+F4A8" "U+F67C" "U+E000-U+E00A"
            "U+F300-U+F313" "U+E5FA-U+E62B"
          ];
          in (builtins.concatStringsSep "," mappings) + " Symbols Nerd Font";
      };
      theme       = "Gruvbox Light Hard";
    };

    lf = {
      commands    = {
        open = ''
        ''${{
          case $(file --mime-type "$f" -b) in
            text/*) $EDITOR $fx;;
            *) for f in $fx; do setsid $OPENER $f > /dev/null 2> /dev/null & done;;
          esac
        }}
        '';
      };
      enable      = true;
      extraConfig =
        let cleaner = pkgs.writeScript "lf-cleaner"
          (builtins.readFile ../config/lf/kitty-cleaner.sh);
        in "set cleaner ${cleaner}";
      previewer   = {
        keybinding = "`";
        source     = with pkgs; writeShellScript "lf-preview" ''
          ${builtins.readFile ../config/lf/kitty-previewer.sh}

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
          config = "source ${toString ../config/neovim/fidget.vim}";
          plugin = fidget-nvim;
        } {
          config = "source ${toString ../config/neovim/gkeep.vim}";
          plugin = gkeep-nvim;
        } {
          config = "source ${toString ../config/neovim/gruvbox-material.vim}";
          plugin = gruvbox-material;
        } {
          config = "source ${toString ../config/neovim/hop.vim}";
          plugin = hop-nvim;
        } {
          config = "lua require('lsp_lines').register_lsp_virtual_lines()";
          plugin = lsp_lines-nvim;
        } {
          config = ''
            set noshowmode
            luafile ${toString ../config/neovim/lualine.lua}
          '';
          plugin = lualine-nvim;
        } {
          config = "luafile ${toString ../config/neovim/null-ls.lua}";
          plugin = null-ls-nvim;
        } {
          config = ''
            set completeopt=menu,menuone,noselect
            luafile ${toString ../config/neovim/cmp.lua}
          '';
          plugin = nvim-cmp.overrideAttrs(_: {
            dependencies =
              [ cmp-buffer cmp-nvim-lsp cmp-nvim-lsp-signature-help cmp-path ];
          });
        } {
          config = "lua require('colorizer').setup({'css','lua','nix','vim'})";
          plugin = nvim-colorizer-lua;
        } {
          config = ''
            source ${toString ../config/neovim/lspconfig.vim}
            luafile ${toString ../config/neovim/lspconfig.lua}
          '';
          plugin = nvim-lspconfig.overrideAttrs(_: {
            dependencies = [ lua-dev-nvim SchemaStore-nvim ];
          });
        } {
          config = "luafile ${toString ../config/neovim/metals.lua}";
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
              telescope-lsp-handlers-nvim telescope-tele-tabby-nvim
              telescope-vim-bookmarks-nvim
           ];
          });
        } {
          config = "vmap <C-v><C-v> :VBox<CR>";
          plugin = venn-nvim;
        } {
          config = "source ${toString ../config/neovim/bookmark.vim}";
          plugin = vim-bookmarks;
        } {
          config = "source ${toString ../config/neovim/markdown.vim}";
          plugin = vim-markdown;
        } {
          config = "source ${toString ../config/neovim/mergetool.vim}";
          plugin = vim-mergetool;
        } {
          config = "source ${toString ../config/neovim/oscyank.vim}";
          plugin = vim-oscyank;
        } {
          config = "source ${toString ../config/neovim/signify.vim}";
          plugin = vim-signify;
        } {
          config = ''
            source ${toString ../config/neovim/zk.vim}
            luafile ${toString ../config/neovim/zk.lua}
          '';
          plugin = zk-nvim;
        }
        commentary git-messenger-vim surround vim-cool vim-gh-line vim-sleuth
      ];
      enable        = true;
      extraPackages =
        let
          default      = with pkgs; [
            buildifier cargo coursier fd fish gopls jq luaformatter openjdk
            pandoc ripgrep rnix-lsp rust-analyzer rustc shellcheck shfmt statix
            sumneko-lua-language-server zk
          ];
          nodePackages = with pkgs.nodePackages; [
            bash-language-server dockerfile-language-server-nodejs
            markdownlint-cli pyright vscode-json-languageserver
          ];
        in default ++ nodePackages;
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
      matchBlocks         = let config = { identitiesOnly = true; }; in {
        cerberus     = config // {
          hostname     = "192.168.1.1";
          identityFile = [ (toString ../config/ssh/jupblb/id_ed25519) ];
          user         = "root";
        };
        dionysus     = config // {
          hostname     = "jupblb.ddns.net";
          identityFile = [ (toString ../config/ssh/jupblb/id_ed25519) ];
          port         = 1995;
          sendEnv      = [ "BAT_THEME" ];
        };
        "github.com" = config // {
          hostname     = "github.com";
          identityFile = [ (toString ../config/ssh/git/id_ed25519) ];
        };
        poseidon     = config // {
          hostname     = "poseidon.kielbowi.cz";
          identityFile = [ (toString ../config/ssh/jupblb/id_ed25519) ];
          sendEnv      = [ "BAT_THEME" ];
        };
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
          in builtins.concatStringsSep "" (map (e: "$" + e) line);
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
      enable                = true;
      enableBashIntegration = false;
      options               = [ "--cmd cd" ];
    };
  };

  xdg = {
    configFile = {
      "lf/icons".source                = pkgs.fetchurl {
        sha256 = "04jnldz0y2fj4ymypzmvs7jjbvvjrwzdp99qp9r12syfk65nh9cn";
        url    = "https://github.com/gokcehan/lf/raw/master/etc/icons.example";
      };
      "nvim/spell/pl.utf-8.spl".source = pkgs.fetchurl {
        sha256 = "1sg7hnjkvhilvh0sidjw5ciih0vdia9vas8vfrd9vxnk9ij51khl";
        url    = "http://ftp.vim.org/vim/runtime/spell/pl.utf-8.spl";
      };
      "telescope/config".text          =
        let theme = pkgs.fetchurl {
          sha256 = "0lg7d0nw3z1awm84kzkbhbpvfqn60dhy6rdd6cprhdss40l9h2h4";
          url    =
            "https://github.com/omar-polo/telescope/raw/main/contrib/light.config";
        };
        in ''
          ${builtins.readFile theme}
          ${builtins.readFile ../config/telescope.txt}
        '';
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
