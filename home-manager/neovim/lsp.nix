{ pkgs, ... }: {
  programs = {
    neovim = {
      extraPackages =
        let
          packages        = with pkgs; [
            actionlint clang fish impl jq jdt-language-server lemminx
            lua-language-server marksman nil pandoc pyright ruff-lsp shellcheck
            shfmt yaml-language-server
          ];
          haskellPackages = with pkgs.haskellPackages;
            [ cabal-fmt haskell-language-server ];
          nodePackages    = with pkgs.nodePackages; [
            bash-language-server dockerfile-language-server-nodejs eslint
            markdownlint-cli typescript-language-server vim-language-server
            vscode-langservers-extracted
          ];
        in packages ++ haskellPackages ++ nodePackages;
      plugins       = with pkgs.vimPlugins; [ {
          config = "luafile ${toString ./config/none-ls.lua}";
          plugin = none-ls-nvim.overrideAttrs(_: {
            dependencies = [ plenary-nvim ];
          });
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
        }
      ];
    };
  };

  xdg.configFile = {
    # https://github.com/igorshubovych/markdownlint-cli#configuration
    # https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md
    "markdownlint".source = toString ./config/markdownlint.json;
  };
}
