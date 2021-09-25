{ config, lib, pkgs, ... }:

{
  home = {
    file             = { ".ammonite/predef.sc".source = pkgs.ammonite.predef; };
    packages         = with pkgs; [ ammonite git-crypt gore ripgrep zk ];
    sessionPath      = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      DOOMDIR      = ../config/doom;
      DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
      EDITOR       = "nvim";
      GOROOT       = "${pkgs.go}/share/go";
    };
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

    emacs = {
      enable        = true;
      extraPackages =
        let
          aspell'  = pkgs.aspellWithDicts(dicts: with dicts; [
            en en-computers en-science pl
          ]);
          packages = with pkgs; [ fd fontconfig languagetool ripgrep sqlite ];
        in epkgs: [ aspell' ] ++ packages;
      package       = pkgs.emacs-nox;
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
      plugins              = lib.mapAttrsToList
        (name: pkg: { name = name; src = pkg; }) pkgs.fish-plugins;
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
      goPath = "${config.xdg.dataHome}/go";
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
          "nvim -c 'setl ft=man | call clearmatches() | autocmd VimEnter * norm G{}'";
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
      userEmail   = "mpkielbowicz@gmail.com";
      userName    = "jupblb";
    };

    neovim = {
      coc           = {
        enable   = true;
        settings = rec {
          diagnostic                = {
            errorSign         = " ";
            hintSign          = " ";
            infoSign          = " ";
            virtualText       = true;
            virtualTextPrefix = "  ";
            warningSign       = " ";
          };
          diagnostic-languageserver = {
            filetypes       = {
              dockerfile = "hadolint";
              fish       = "fish";
              lua        = "luacheck";
              sh         = "shellcheck";
              vim        = "vint";
            };
            formatters      = rec {
              lua-format = { command = "${pkgs.luaformatter}/bin/lua-format"; };
              pandoc     = {
                args    = 
                  [ "-f" "markdown" "-s" "-t" "markdown" "--columns=80" "-" ];
                command = "${pkgs.pandoc}/bin/pandoc";
              };
              pandoc-md  = {
                args    = [
                  "-f" "markdown+lists_without_preceding_blankline" "-s" "-t"
                    "gfm+raw_tex" "--columns=80" "-"
                ];
                command = "${pkgs.pandoc}/bin/pandoc";
              };
              shfmt      = {
                args    = [ "-i" "2" "-filename" "%filepath" ];
                command = "${pkgs.shfmt}/bin/shfmt";
              };
            };
            formatFiletypes = {
              fish     = "fish_indent";
              lua      = "lua-format";
              markdown = "pandoc-md";
              pandoc   = "pandoc";
              sh       = "shfmt";
            };
            linters         = {
              hadolint     = { command = "${pkgs.hadolint}/bin/hadolint"; };
              luacheck     = {
                args    = [
                  "--codes" "--filename" "%filepath" "--formatter" "plain"
                    "--globals" "vim" "--ranges" "-"
                ];
                command = "${pkgs.luaPackages.luacheck}/bin/luacheck";
              };
              nix-linter   = { command = "${pkgs.nix-linter}/bin/nix-linter"; };
              shellcheck   = { command = "${pkgs.shellcheck}/bin/shellcheck"; };
              vint         = { command = "${pkgs.vim-vint}/bin/vim-vint"; };
            };
            mergeConfig     = true;
          };
          eslint                    = { packageManager = npm.binPath; };
          go.goplsPath              = "${pkgs.gopls}/bin/gopls";
          hover.floatConfig         = { maxWidth = 90; };
          languageserver            = {
            bash = {
              args               = [ "start" ];
              command            = let nodePackages = pkgs.nodePackages; in
                "${nodePackages.bash-language-server}/bin/bash-language-server";
              disableDiagnostics = true;
              filetypes          = [ "sh" ];
            };
            zk   = {
              command   = "zk";
              args      = [ "lsp" ];
              filetypes = [ "markdown" ];
            };
          };
          metals                    = {
            gradleScript                      = "${pkgs.gradle}/bin/gradle";
            javaHome                          = "${pkgs.openjdk11}";
            mavenScript                       = "${pkgs.maven}/bin/mvn";
            millScript                        = "${pkgs.mill}/bin/mill";
            sbtScript                         = "${pkgs.sbt}/bin/sbt";
            showImplicitArguments             = true;
            showImplicitConversionsAndClasses = true;
            statusBarEnabled                  = true;
          };
          npm.binPath               = "${pkgs.nodePackages.npm}/bin/npm";
          suggest                   = { invalidInsertCharacters = []; };
          tabnine                   = {
            binary_path       = "${pkgs.tabnine}/bin/TabNine";
            disable_filetypes = [ "go" "scala" ];
          };
          tsserver                  = { npm = npm.binPath; };
        };
      };
      extraConfig   = "source ${toString ../config/neovim/init.vim}";
      plugins       = with pkgs.vimPlugins; [ {
          config = "nmap <C-x> :Bdelete!<CR> | nmap <C-S-x> :Bwipeout!<CR>";
          plugin = bufdelete-nvim;
        } {
          config = "source ${toString ../config/neovim/coc.vim}";
          plugin = coc-nvim.overrideAttrs(_: {
            dependencies = [
              coc-css coc-diagnostic coc-eslint coc-go coc-html coc-json
                coc-metals coc-tabnine coc-tsserver
              telescope-coc-nvim
            ];
          });
        } {
          config = "let $GLOW_STYLE = 'light'";
          plugin = glow-nvim;
        } {
          config = "source ${toString ../config/neovim/gruvbox-material.vim}";
          plugin = gruvbox-material;
        } {
          config = "source ${toString ../config/neovim/hop.vim}";
          plugin = hop-nvim;
        } {
          config = "luafile ${toString ../config/neovim/lualine.lua}";
          plugin = lualine-nvim.overrideAttrs(_: {
            dependencies = [ nvim-gps vim-sleuth ];
          });
        } {
          config = "set tabline=%!v:lua.require\\'luatab\\'.tabline()";
          plugin = luatab-nvim;
        } {
          config =
            "lua require('bqf').setup({preview = {win_height = 99, wrap = true}})";
          plugin = nvim-bqf;
        } {
          config = "lua require('colorizer').setup()";
          plugin = nvim-colorizer-lua;
        } {
          config = "source ${toString ../config/neovim/tree.vim}";
          plugin = nvim-tree-lua;
        } {
          config = "luafile ${toString ../config/neovim/treesitter.lua}";
          plugin =
            let nvim-treesitter' =
              nvim-treesitter.withPlugins(_: pkgs.tree-sitter.allGrammars);
            in nvim-treesitter'.overrideAttrs(_: {
              dependencies = [
                nvim-treesitter-refactor nvim-treesitter-textobjects vim-matchup
              ];
            });
        } {
          config = "luafile ${toString ../config/neovim/devicons.lua}";
          plugin = nvim-web-devicons;
        } {
          config = "luafile ${toString ../config/neovim/telescope.lua}";
          plugin = telescope-nvim.overrideAttrs(old: {
            dependencies = old.dependencies ++ [ telescope-fzf-native-nvim ];
          });
        } {
          config = "source ${toString ../config/neovim/venn.vim}";
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
          config = "source ${toString ../config/neovim/pandoc.vim}";
          plugin = vim-pandoc-syntax;
        } {
          config = "source ${toString ../config/neovim/signify.vim}";
          plugin = vim-signify;
        }
        git-messenger-vim surround vim-cool
      ];
      enable        = true;
      extraPackages = with pkgs; [ fd glow ripgrep ];
      vimAlias      = true;
      vimdiffAlias  = true;
      withNodeJs    = true;
      withPython3   = false;
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
          pihole       = config // { port = 1998; user = "root"; };
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
  };

  xdg = {
    configFile = {
      "emacs"                 = {
        onChange = "${config.xdg.configHome}/emacs/bin/doom install";
        source   = builtins.fetchGit {
          ref = "develop";
          url = https://github.com/hlissner/doom-emacs.git;
        };
      };
      "zk/config.toml".source =
        let toml = pkgs.formats.toml {}; in toml.generate "config.toml" {
          format = { markdown.link-drop-extension = false; };
          lsp    = { diagnostics = { wiki-title = "info"; }; };
          note   = { id-charset = "hex"; id-length = 8; };
          tool   = {
            editor      = "nvim";
            fzf-preview = "${pkgs.glow}/bin/glow --style light {-1}";
          };
        };
    };
    enable     = true;
  };
}
