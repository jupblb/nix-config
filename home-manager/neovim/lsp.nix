{ pkgs, ... }: {
  programs = {
    neovim = {
      extraPackages =
        let
          default        = with pkgs; [
            actionlint clang fish impl jq jdt-language-server lemminx
            lua-language-server marksman nil pandoc shellcheck shfmt
            yaml-language-server
          ];
          nodePackages   = with pkgs.nodePackages; [
            bash-language-server dockerfile-language-server-nodejs eslint
            graphql-language-service-cli markdownlint-cli
            typescript-language-server vim-language-server
            vscode-langservers-extracted
          ];
          nodeAtPackages = [
            pkgs.nodePackages."@prisma/language-server"
            pkgs.nodePackages."@tailwindcss/language-server"
          ];
          pythonPackages = with pkgs.python3Packages; [ ruff-lsp ];
        in default ++ nodePackages ++ nodeAtPackages ++ pythonPackages;
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
            dependencies = [ inc-rename-nvim neodev-nvim ];
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
