{ config, pkgs, ... }: {
  home.sessionVariables = {
    NVIM_ENV_JSON       = "/tmp/nvim-\$KITTY_WINDOW_ID\$WEZTERM_PANE.json";
    NVIM_LISTEN_ADDRESS = "/tmp/nvim-\$KITTY_WINDOW_ID\$WEZTERM_PANE.socket";
  };

  programs = {
    fish = {
      functions = {
        fish_prompt = ''
          if test -e $NVIM_ENV_JSON
              for value in \
                (${pkgs.jq}/bin/jq -r 'keys[] as $k | "\($k) \(.[$k])"' $NVIM_ENV_JSON)
                  set -l value (echo "$value" | ${pkgs.gnused}/bin/sed 's/\",\"/\"\ \"/g')
                  set -l value (echo "$value" | ${pkgs.coreutils}/bin/tr -d '[]')
                  eval (echo "set -gx $value")
              end
          end
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
      extraPackages = with pkgs; [ fd ripgrep zig ];
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
          config = ''
            set completeopt=menu,menuone,noselect
            luafile ${toString ./config/cmp.lua}
          '';
          plugin = cmp-nvim-lsp-signature-help.overrideAttrs(old: {
            dependencies = old.dependencies ++ [
              cmp-latex-symbols cmp-nvim-lsp cmp-path cmp_luasnip luasnip
            ];
          });
        } {
          config = "luafile ${toString ./config/colorizer.lua}";
          plugin = nvim-colorizer-lua;
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
              nvim-neoclip-lua telescope-live-grep-args-nvim
              telescope-lsp-handlers-nvim telescope-ui-select-nvim
              telescope-undo-nvim
            ];
          });
        } {
          config = "luafile ${toString ./config/osc52.lua}";
          plugin = nvim-osc52;
        } {
          config = "source ${toString ./config/signify.vim}";
          plugin = vim-signify;
        }
        commentary mkdir-nvim surround vim-cool vim-gh-line vim-sleuth
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
    "nvim/snippets".source           = toString ./snippets;
  };
}
