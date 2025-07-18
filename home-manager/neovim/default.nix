{ config, pkgs, ... }: {
  home = {
    sessionVariables = {
      NVIM_ENV_JSON       = "/tmp/nvim-\$KITTY_WINDOW_ID.json";
      NVIM_LISTEN_ADDRESS = "/tmp/nvim-\$KITTY_WINDOW_ID.socket";
    };
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
          packages     = with pkgs;
            [ curl fish-lsp harper marksman nil pandoc ripgrep shfmt ];
          nodePackages = with pkgs.nodePackages; [ bash-language-server ];
        in packages ++ nodePackages;
      plugins       = with pkgs.vimPlugins; [ {
          config = "luafile ${toString ./config/codecompanion.lua}";
          plugin = codecompanion-nvim;
        } {
          config = "luafile ${toString ./config/fidget.lua}";
          plugin = fidget-nvim;
        } {
          config = "source ${toString ./config/gruvbox-material.vim}";
          plugin = gruvbox-material;
        } {
          config = "luafile ${toString ./config/inc-rename.lua}";
          plugin = inc-rename-nvim;
        } {
          config = "luafile ${toString ./config/no-neck-pain.lua}";
          plugin = no-neck-pain-nvim;
        } {
          config = ''
            set completeopt=menu,menuone,noselect
            luafile ${toString ./config/cmp.lua}
          '';
          plugin = nvim-cmp.overrideAttrs(_: {
            dependencies = [
              cmp-async-path cmp-nvim-lsp cmp-nvim-lsp-signature-help
              cmp-treesitter copilot-cmp copilot-lua luasnip
            ];
          });
        } {
          config = "luafile ${toString ./config/colorizer.lua}";
          plugin = nvim-colorizer-lua;
        } {
          config = "luafile ${toString ./config/lspconfig.lua}";
          plugin = nvim-lspconfig;
        } {
          config = "luafile ${toString ./config/pqf.lua}";
          plugin = nvim-pqf;
        } {
          config = "luafile ${toString ./config/treesitter.lua}";
          plugin = nvim-treesitter.withAllGrammars;
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
          config = "source ${toString ./config/signify.vim}";
          plugin = vim-signify;
        }
        mkdir-nvim vim-cool vim-gh-line vim-matchup vim-sleuth vim-surround
      ];
      vimdiffAlias  = true;
      withNodeJs    = true;
      withPython3   = true;
      withRuby      = false;
    };
  };

  xdg.configFile = {
    "nvim/spell/pl.utf-8.spl".source = pkgs.fetchurl {
      sha256 = "1sg7hnjkvhilvh0sidjw5ciih0vdia9vas8vfrd9vxnk9ij51khl";
      url    = "http://ftp.vim.org/vim/runtime/spell/pl.utf-8.spl";
    };
  };
}
