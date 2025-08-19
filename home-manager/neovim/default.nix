{ pkgs, ... }: {
  home = {
    packages         = with pkgs; [ zoekt ];
    sessionVariables = {
      CTAGS_COMMAND       = "${pkgs.universal-ctags}/bin/ctags";
      NVIM_LISTEN_ADDRESS = "/tmp/nvim-\$KITTY_WINDOW_ID.socket";
    };
  };

  programs = {
    fish = { functions.vim = builtins.readFile(./singleton.fish); };

    neovim = {
      defaultEditor  = true;
      enable         = true;
      extraConfig    = builtins.readFile(./config/init.vim);
      extraLuaConfig = builtins.readFile(./config/init.lua);
      extraPackages  =
        let
          packages     = with pkgs;
            [ curl fish-lsp marksman nil pandoc ripgrep shfmt ];
          nodePackages = with pkgs.nodePackages; [ bash-language-server ];
        in packages ++ nodePackages;
      plugins        = with pkgs.vimPlugins; [
        {
          config = builtins.readFile(./config/fidget.lua);
          plugin = fidget-nvim;
          type   = "lua";
        } {
          config = builtins.readFile(./config/gruvbox-material.vim);
          plugin = gruvbox-material;
        } {
          config = builtins.readFile(./config/inc-rename.lua);
          plugin = inc-rename-nvim;
          type   = "lua";
        } {
          config = builtins.readFile(./config/no-neck-pain.lua);
          plugin = no-neck-pain-nvim;
          type   = "lua";
        } {
          config = builtins.readFile(./config/cmp.lua);
          plugin = nvim-cmp.overrideAttrs(_: {
            dependencies = [
              cmp-async-path cmp-nvim-lsp cmp-nvim-lsp-signature-help
              cmp-treesitter copilot-cmp copilot-lua luasnip
            ];
          });
          type   = "lua";
        } {
          config = builtins.readFile(./config/colorizer.lua);
          plugin = nvim-colorizer-lua;
          type   = "lua";
        } {
          config = builtins.readFile(./config/lspconfig.lua);
          plugin = nvim-lspconfig;
          type   = "lua";
        } {
          config = builtins.readFile(./config/treesitter.lua);
          plugin = nvim-treesitter.withAllGrammars;
          type   = "lua";
        } {
          config = builtins.readFile(./config/devicons.lua);
          plugin = nvim-web-devicons;
          type   = "lua";
        } {
          config = builtins.readFile(./config/telescope.lua);
          plugin = telescope-fzf-native-nvim.overrideAttrs(old: {
            dependencies = old.dependencies ++ [
              telescope-file-browser-nvim telescope-live-grep-args-nvim
              telescope-lsp-handlers-nvim telescope-ui-select-nvim
            ];
          });
          type   = "lua";
        } {
          config = builtins.readFile(./config/signify.vim);
          plugin = vim-signify;
        } {
          config = ''
            require('zoekt').setup({})
            vim.keymap.set('n', '<Leader>q', telescope.extensions.zoekt.zoekt)
          '';
          plugin = zoekt-nvim;
          type   = "lua";
        }
      ] ++
        [ mkdir-nvim vim-cool vim-gh-line vim-matchup vim-sleuth vim-surround ];
      vimdiffAlias   = true;
      withNodeJs     = true;
      withPython3    = false;
      withRuby       = false;
    };
  };
}
