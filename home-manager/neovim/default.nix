{ pkgs, ... }: {
  home = {
    packages         = with pkgs; [ zoekt ];
    sessionVariables = {
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
      extraPackages  = with pkgs; [
        bash-language-server curl fish-lsp marksman nil pandoc ripgrep shfmt
      ];
      plugins        = with pkgs.vimPlugins; [
        {
          config = "require('amp').setup({ log_level = 'error' })";
          plugin = amp-nvim;
          type   = "lua";
        } {
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
              telescope-file-browser-nvim telescope-ui-select-nvim zoekt-nvim
            ];
          });
          type   = "lua";
        } {
          config = builtins.readFile(./config/signify.vim);
          plugin = vim-signify;
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
