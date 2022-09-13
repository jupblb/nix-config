{ config, lib, pkgs, ... }: {
  home = {
    activation       = {
      nvim = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD ${config.programs.neovim.finalPackage}/bin/nvim \
          --headless +UpdateRemotePlugins +quit && echo
      '';
    };
    packages         = with pkgs; [ neovim-remote ];
    sessionVariables = {
      EDITOR              = "nvim";
      NVIM_LISTEN_ADDRESS = "/tmp/nvimsocket-\$KITTY_WINDOW_ID.socket";
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
          config = "nmap <C-x> :Bdelete!<CR> | nmap <C-S-x> :Bwipeout!<CR>";
          plugin = bufdelete-nvim;
        } {
          config = "lua require('git-conflict').setup({})";
          plugin = pkgs.callPackage ./plugin/git-conflict.nix {};
        } {
          config = "luafile ${toString ./config/gitsigns.lua}";
          plugin = gitsigns-nvim;
        } {
          config = "source ${toString ./config/gkeep.vim}";
          plugin = pkgs.callPackage ./plugin/gkeep.nix {};
        } {
          config = "source ${toString ./config/gruvbox-material.vim}";
          plugin = gruvbox-material;
        } {
          config = "source ${toString ./config/hop.vim}";
          plugin = hop-nvim;
        } {
          config = ''
            set noshowmode
            luafile ${toString ./config/lualine.lua}
          '';
          plugin = lualine-nvim;
        } {
          config = "luafile ${toString ./config/luasnip.lua}";
          plugin = luasnip.overrideAttrs(_: {
            dependencies = [ friendly-snippets ];
          });
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
              in [ cmp-buffer cmp-nvim-lsp cmp-path cmp-signature cmp_luasnip ];
          });
        } {
          config =
            "lua require('colorizer').setup({'css','lua', 'markdown', 'nix','vim'})";
          plugin = nvim-colorizer-lua;
        } {
          config = "luafile ${toString ./config/pqf.lua}";
          plugin = pkgs.callPackage ./plugin/pqf.nix {};
        } {
          config = ''
            source ${toString ./config/tree.vim}
            luafile ${toString ./config/tree.lua}
          '';
          plugin = nvim-tree-lua;
        } {
          config = ''
            autocmd VimEnter * highlight TSDefinitionUsage guibg=#d9d87f
            luafile ${toString ./config/treesitter.lua}
          '';
          plugin =
            let
              nvim-treesitter' =
                nvim-treesitter.withPlugins(_: pkgs.tree-sitter.allGrammars);
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
              let
                tele-tabby          =
                  pkgs.callPackage ./plugin/telescope-tele-tabby.nix {};
                telescope-live-grep =
                  pkgs.callPackage ./plugin/telescope-live-grep.nix {};
                telescope-luasnip   =
                  pkgs.callPackage ./plugin/telescope-luasnip.nix {};
              in old.dependencies ++ [
                nvim-neoclip-lua tele-tabby telescope-live-grep
                telescope-lsp-handlers-nvim telescope-luasnip
                telescope-ui-select-nvim telescope-vim-bookmarks-nvim
              ];
          });
        } {
          config = "vmap <C-v><C-v> :VBox<CR>";
          plugin = venn-nvim;
        } {
          config = "source ${toString ./config/bookmark.vim}";
          plugin = vim-bookmarks;
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
