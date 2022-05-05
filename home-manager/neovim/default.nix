{ lib, pkgs, ... }: {
  home = {
    activation       = {
      nvim = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD nvim --headless \
          +UpdateRemotePlugins +TSUpdateSync all +quit && echo
      '';
    };
    sessionVariables = { EDITOR = "nvim"; };
  };

  programs = {
    git   = {
      ignores = [ ".vim-bookmarks" ];
    };

    kitty = {
      settings.scrollback_pager =
        "kitty @ launch --type=overlay --stdin-source=@screen_scrollback nvim -R -c 'autocmd VimEnter * norm G{}' -";
    };

    neovim = {
      enable        = true;
      extraConfig   = "source ${toString ./config/init.vim}";
      extraPackages = with pkgs; [ fd ripgrep ];
      plugins       = with pkgs.vimPlugins; [ {
          config = "nmap <C-x> :Bdelete!<CR> | nmap <C-S-x> :Bwipeout!<CR>";
          plugin = bufdelete-nvim;
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
          config = ''
            set completeopt=menu,menuone,noselect
            luafile ${toString ./config/cmp.lua}
          '';
          plugin = nvim-cmp.overrideAttrs(_: {
            dependencies =
              let lsp-signature =
                pkgs.callPackage ./plugin/cmp-nvim-lsp-signature-help.nix {};
              in [ cmp-buffer cmp-nvim-lsp lsp-signature cmp-path ];
          });
        } {
          config = "lua require('colorizer').setup({'css','lua','nix','vim'})";
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
          plugin = nvim-treesitter.overrideAttrs(_: {
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
              let tele-tabby =
                pkgs.callPackage ./plugin/telescope-tele-tabby.nix {};
              in old.dependencies ++ [
                nvim-neoclip-lua telescope-lsp-handlers-nvim tele-tabby
                telescope-vim-bookmarks-nvim
              ];
          });
        } {
          config = "vmap <C-v><C-v> :VBox<CR>";
          plugin = venn-nvim;
        } {
          config = "source ${toString ./config/bookmark.vim}";
          plugin = vim-bookmarks;
        } {
          config = "source ${toString ./config/markdown.vim}";
          plugin = vim-markdown;
        } {
          config = "source ${toString ./config/mergetool.vim}";
          plugin = vim-mergetool;
        } {
          config = "source ${toString ./config/oscyank.vim}";
          plugin = vim-oscyank;
        } {
          config = "source ${toString ./config/signify.vim}";
          plugin = vim-signify;
        }
        commentary git-messenger-vim surround vim-cool vim-gh-line vim-sleuth
      ];
      vimAlias      = true;
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
  };
}
