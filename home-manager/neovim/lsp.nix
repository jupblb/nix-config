{ config, pkgs, ... }: {
  programs.neovim = {
    extraPackages =
      let
        default      = with pkgs; [
          black buildifier cargo fish gomodifytags gopls gotests
          haskell-language-server impl isort jdt-language-server jq metals
          openjdk pandoc rnix-lsp rust-analyzer rustc shellcheck shfmt statix
          sumneko-lua-language-server
        ];
        nodePackages = with pkgs.nodePackages; [
          bash-language-server dockerfile-language-server-nodejs
          markdownlint-cli pyright vim-language-server
          vscode-json-languageserver yaml-language-server
        ];
      in default ++ nodePackages;
    plugins       = with pkgs.vimPlugins; [ {
        config = "source ${toString ./config/fidget.vim}\n";
        plugin = fidget-nvim;
      } {
        config = "lua require('lsp_lines').setup({})\n";
        plugin = lsp_lines-nvim;
      } {
        config = "luafile ${toString ./config/null-ls.lua}\n";
        plugin = null-ls-nvim.overrideAttrs(_: {
          dependencies = [ plenary-nvim ];
        });
      } {
        config = ''
          source ${toString ./config/lspconfig.vim}
          luafile ${toString ./config/lspconfig.lua}
        '';
        plugin = nvim-lspconfig.overrideAttrs(_: {
          dependencies = [ lua-dev-nvim SchemaStore-nvim ];
        });
      }
    ];
  };

  xdg.configFile = {
    # https://github.com/igorshubovych/markdownlint-cli#configuration
    # https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md
    "markdownlint".source = toString ./config/markdownlint.json;
  };
}
