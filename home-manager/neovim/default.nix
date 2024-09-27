{ config, pkgs, ... }: {
  home.sessionVariables = {
    NVIM_ENV_JSON       = "/tmp/nvim-\$KITTY_WINDOW_ID\$WEZTERM_PANE.json";
    NVIM_LISTEN_ADDRESS = "/tmp/nvim-\$KITTY_WINDOW_ID\$WEZTERM_PANE.socket";
  };

  programs = {
    fish = {
      functions = {
        fish_prompt = ''
          set -l jq  "${pkgs.jq}/bin/jq"
          set -l sed "${pkgs.gnused}/bin/sed"
          set -l tr  "${pkgs.coreutils}/bin/tr"
          ${builtins.readFile ./variables.fish}
        '';
        vim         = builtins.readFile ./singleton.fish;
      };
    };

    kitty = {
      settings.scrollback_pager =
        "${pkgs.fish}/bin/fish -c '${pkgs.vtclean}/bin/vtclean | ${config.programs.neovim.finalPackage}/bin/nvim -R -c \"normal G{}\"'";
    };

    neovim = {
      defaultEditor = true;
      enable        = true;
      extraConfig   = ''
        source ${toString ./config/init.vim}
        luafile ${toString ./config/init.lua}
        luafile ${toString ./config/vim-env.lua}
      '';
      extraPackages =
        let
          packages     = with pkgs; [
            fish jq lua-language-server marksman nil pandoc ripgrep shellcheck
            shfmt yaml-language-server
          ];
          nodePackages = with pkgs.nodePackages; [
            bash-language-server markdownlint-cli vscode-json-languageserver
          ];
        in packages ++ nodePackages;
      plugins       = with pkgs.vimPlugins; [ {
          config = "lua require('fidget').setup({})";
          plugin = fidget-nvim;
        } {
          config = "source ${toString ./config/gruvbox-material.vim}";
          plugin = gruvbox-material;
        } {
          config = "luafile ${toString ./config/no-neck-pain.lua}";
          plugin = no-neck-pain-nvim;
        } {
          config = "luafile ${toString ./config/none-ls.lua}";
          plugin = none-ls-nvim.overrideAttrs(_: {
            dependencies = [ plenary-nvim ];
          });
        } {
          config = ''
            set completeopt=menu,menuone,noselect
            luafile ${toString ./config/cmp.lua}
          '';
          plugin = nvim-cmp.overrideAttrs(_: {
            dependencies =
              [ cmp-async-path cmp-treesitter copilot-cmp copilot-lua luasnip ];
          });
        } {
          config = "luafile ${toString ./config/colorizer.lua}";
          plugin = nvim-colorizer-lua;
        } {
          config = ''
            source ${toString ./config/lspconfig.vim}
            luafile ${toString ./config/lspconfig.lua}
          '';
          plugin = nvim-lspconfig.overrideAttrs(_: {
            dependencies = [
              cmp-nvim-lsp cmp-nvim-lsp-signature-help inc-rename-nvim
              neodev-nvim
            ];
          });
        } {
          config = "luafile ${toString ./config/pqf.lua}";
          plugin = nvim-pqf;
        } {
          config = "luafile ${toString ./config/treesitter.lua}";
          plugin = nvim-ts-context-commentstring.overrideAttrs(_: {
            dependencies = [ (nvim-treesitter.withAllGrammars) vim-matchup ];
          });
        } {
          config = "luafile ${toString ./config/devicons.lua}";
          plugin = nvim-web-devicons;
        } {
          config = ''
            source ${toString ./config/telescope.vim}
            luafile ${toString ./config/telescope.lua}
          '';
          plugin = telescope-fzf-native-nvim.overrideAttrs(old: {
            dependencies = old.dependencies ++ [
              telescope-file-browser-nvim telescope-lsp-handlers-nvim
              telescope-ui-select-nvim
            ];
          });
        } {
          config = "luafile ${toString ./config/osc52.lua}";
          plugin = nvim-osc52;
        } {
          config = "source ${toString ./config/signify.vim}";
          plugin = vim-signify;
        }
        commentary mkdir-nvim neorepl-nvim vim-cool vim-gh-line vim-sleuth
      ];
      vimdiffAlias  = true;
      withNodeJs    = true;
      withPython3   = true;
      withRuby      = false;
    };
  };

  xdg.configFile = {
    # https://github.com/igorshubovych/markdownlint-cli#configuration
    # https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md
    "markdownlint".source = toString ./config/markdownlint.json;
    "nvim/spell/pl.utf-8.spl".source = pkgs.fetchurl {
      sha256 = "1sg7hnjkvhilvh0sidjw5ciih0vdia9vas8vfrd9vxnk9ij51khl";
      url    = "http://ftp.vim.org/vim/runtime/spell/pl.utf-8.spl";
    };
  };
}
