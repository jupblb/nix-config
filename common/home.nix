{ config, lib, pkgs, ... }:

{
  home = {
    file             = { ".ammonite/predef.sc".source = pkgs.ammonite.predef; };
    packages         = with pkgs; [ ammonite git-crypt gore ripgrep ];
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
        ls            = builtins.readFile ../config/fish/exa.fish;
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
        color.ui          = true;
        core.mergeoptions = "--no-edit";
        fetch.prune       = true;
        pull.rebase       = true;
        push.default      = "upstream";
        submodule.recurse = true;
      };
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
        allow_remote_control          = "socket-only";
        background                    = "#f9f5d7";
        clipboard_control             =
          "write-clipboard write-primary no-append";
        enabled_layouts               = "splits";
        enable_audio_bell             = "no";
        foreground                    = "#282828";
        listen_on                     = "unix:/tmp/kitty";
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
            errorSign         = " ";
            hintSign          = " ";
            infoSign          = " ";
            virtualText       = true;
            virtualTextPrefix = "  ";
            warningSign       = " ";
          };
          diagnostic-languageserver = {
            filetypes       = {
              dockerfile = "hadolint";
              fish       = "fish";
              sh         = "shellcheck";
              vim        = "vint";
            };
            formatters      = {
              lua-format = { command = "${pkgs.luaformatter}/bin/lua-format"; };
              mdformat   = {
                args    = [ "-" ];
                command = "${pkgs.python3Packages.mdformat}/bin/mdformat";
              };
              shfmt      = {
                args    = [ "-i" "2" "-filename" "%filepath" ];
                command = "${pkgs.shfmt}/bin/shfmt";
              };
            };
            formatFiletypes = {
              fish     = "fish_indent";
              lua      = "lua-format";
              markdown = "mdformat";
              sh       = "shfmt";
            };
            linters         = {
              hadolint   = { command = "${pkgs.hadolint}/bin/hadolint"; };
              nix-linter = { command = "${pkgs.nix-linter}/bin/nix-linter"; };
              shellcheck = { command = "${pkgs.shellcheck}/bin/shellcheck"; };
              vint       = { command = "${pkgs.vim-vint}/bin/vim-vint"; };
            };
            mergeConfig     = true;
          };
          eslint                    = { packageManager = npm.binPath; };
          go.goplsPath              = "${pkgs.gopls}/bin/gopls";
          languageserver            = {
            bash = {
              args               = [ "start" ];
              command            = let nodePackages = pkgs.nodePackages; in
                "${nodePackages.bash-language-server}/bin/bash-language-server";
              disableDiagnostics = true;
              filetypes          = [ "sh" ];
            };
          };
          markdownlint              = {
            config = {
              line-length  = { code_blocks = false; tables = false; };
              no-bare-urls = false;
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
          preferences               = {
            formatOnSaveFiletypes = [ "fish" "lua" "go" "scala" "markdown" ];
          };
          suggest                   = { enablePreselect = true; };
          tabnine                   = {
            binary_path       = "${pkgs.tabnine}/bin/TabNine";
            disable_filetypes = [ "go" "scala" ];
          };
          tsserver                  = { npm = npm.binPath; };
        };
      };
      extraConfig   = "source ${toString ../config/neovim/init.vim}";
      plugins       = with pkgs.vimPlugins; [ {
          config = "source ${toString ../config/neovim/coc.vim}";
          plugin = coc-nvim.overrideAttrs(_: {
            dependencies = [
              coc-css coc-diagnostic coc-eslint coc-go coc-html coc-json
                coc-markdownlint coc-metals coc-tabnine coc-tsserver
              telescope-coc
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
          plugin = lualine-nvim;
        } {
          config = "lua vim.o.tabline = '%!v:lua.require\\'luatab\\'.tabline()'";
          plugin = luatab-nvim;
        } {
          config = "source ${toString ../config/neovim/mkdx.vim}";
          plugin = mkdx;
        } {
          config = "nnoremap <Leader>L :lua require('nabla').action()<CR>";
          plugin = nabla-nvim;
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
              dependencies = [ nvim-treesitter-refactor ];
            });
        } {
          config = "luafile ${toString ../config/neovim/devicons.lua}";
          plugin = nvim-web-devicons;
        } {
          config = "luafile ${toString ../config/neovim/telescope.lua}";
          plugin = telescope-nvim.overrideAttrs(old: {
            dependencies = old.dependencies ++
              [ telescope-fzf-writer-nvim telescope-fzy-native-nvim ];
          });
        } {
          config = "source ${toString ../config/neovim/trouble.vim}";
          plugin = trouble-nvim;
        } {
          config = "source ${toString ../config/neovim/venn.vim}";
          plugin = venn-nvim;
        } {
          config = ''
            nnoremap <Leader>r :Grepper -tool rg<CR>
            nnoremap <Leader>R :Grepper -buffer -noquickfix -tool rg<CR>
          '';
          plugin = vim-grepper.overrideAttrs(_: {
            patches = [ ../config/neovim/grepper.diff ];
          });
        } {
          config = "source ${toString ../config/neovim/signify.vim}";
          plugin = vim-signify;
        }
        git-messenger-vim vim-cool vim-sleuth
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

  xdg.enable = true;
}
