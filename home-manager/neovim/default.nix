{ config, lib, pkgs, ... }: {
  home = {
    activation       = {
      nvim = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD ${config.programs.neovim.finalPackage}/bin/nvim \
          --headless +UpdateRemotePlugins +quit && echo
      '';
    };
    sessionVariables = {
      EDITOR              = "nvim";
      NVIM_LISTEN_ADDRESS = "/tmp/nvim-\$KITTY_WINDOW_ID\$WEZTERM_PANE.socket";
    };
  };

  programs = {
    fish = {
      functions.vim = builtins.readFile ./singleton.fish;
    };

    git = {
      ignores = [ ".vim-bookmarks" ];
    };

    kitty = {
      settings.scrollback_pager =
        "kitty @ launch --type=overlay --stdin-source=@screen_scrollback nvim -R -c 'autocmd VimEnter * norm G{}' -";
    };

    neovim = {
      enable        = true;
      extraConfig   = ''
        source ${toString ./config/init.vim}
        luafile ${toString ./config/init.lua}
      '';
      extraPackages = with pkgs; [ fd ripgrep ];
      plugins       = with pkgs.vimPlugins; [ {
          config = "source ${toString ./config/gruvbox-material.vim}";
          plugin = gruvbox-material;
        } {
          config = ''
            set completeopt=menu,menuone,noselect
            luafile ${toString ./config/cmp.lua}
          '';
          plugin = nvim-cmp.overrideAttrs(_: {
            dependencies =
              let cmp-signature = cmp-nvim-lsp-signature-help.overrideAttrs(_: {
                dependencies = [];
              });
              in [
                cmp-buffer cmp-latex-symbols cmp-nvim-lsp cmp-pandoc-references
                cmp-path cmp-signature cmp_luasnip luasnip
              ];
          });
        } {
          config = "luafile ${toString ./config/colorizer.lua}";
          plugin = nvim-colorizer-lua;
        } {
          config = "luafile ${toString ./config/pqf.lua}";
          plugin = pkgs.callPackage ./plugin/pqf.nix {};
        } {
          config = ''
            autocmd VimEnter * highlight TSDefinitionUsage guibg=#d9d87f
            luafile ${toString ./config/treesitter.lua}
          '';
          plugin =
            let nvim-treesitter' = pkgs.callPackage ./plugin/tree-sitter.nix {
              inherit (pkgs.vimPlugins) nvim-treesitter;
            };
            in nvim-treesitter'.overrideAttrs(_: {
              dependencies = [
                nvim-treesitter-refactor nvim-treesitter-textobjects
                nvim-ts-context-commentstring vim-matchup
              ];
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
            dependencies =
              let telescope-live-grep =
                pkgs.callPackage ./plugin/telescope-live-grep.nix {};
              in old.dependencies ++ [
                nvim-neoclip-lua telescope-live-grep telescope-lsp-handlers-nvim
                telescope-ui-select-nvim
              ];
          });
        } {
          config = "vmap <C-v><C-v> :VBox<CR>";
          plugin = venn-nvim;
        } {
          config = "source ${toString ./config/oscyank.vim}";
          plugin = vim-oscyank;
        } {
          config = "source ${toString ./config/signify.vim}";
          plugin = vim-signify;
        } {
          config = "luafile ${toString ./config/zen-mode.lua}";
          plugin = zen-mode-nvim;
        }
        commentary git-messenger-vim surround vim-cool vim-gh-line vim-sleuth
      ];
      vimdiffAlias  = true;
      withNodeJs    = false;
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
