{ config, pkgs, ... }: {
  programs.neovim = {
    extraPackages =
      let
        default      = with pkgs; [
          black buildifier cargo fish gomodifytags gopls gotests
          haskell-language-server impl isort jdt-language-server jq ltex-ls
          metals open-policy-agent openjdk pandoc rnix-lsp rust-analyzer rustc
          shellcheck shfmt statix sumneko-lua-language-server
        ];
        latexindent  = pkgs.texlive.latexindent.pkgs;
        nodePackages = with pkgs.nodePackages; [
          bash-language-server dockerfile-language-server-nodejs
          markdownlint-cli pyright vim-language-server
          vscode-json-languageserver
        ];
      in default ++ latexindent ++ nodePackages;
    plugins       = with pkgs.vimPlugins; [ {
        config = "source ${toString ./config/fidget.vim}";
        plugin = fidget-nvim;
      } {
        config = "lua require('lsp_lines').setup({})";
        plugin = lsp_lines-nvim;
      } {
        config = "luafile ${toString ./config/null-ls.lua}";
        plugin = null-ls-nvim.overrideAttrs(_: {
          dependencies = [ plenary-nvim ];
        });
      } {
        config = ''
          source ${toString ./config/lspconfig.vim}
          luafile ${toString ./config/lspconfig.lua}
        '';
        plugin =
          let ltex-ls     = pkgs.callPackage ./plugin/ltex.nix {};
          in nvim-lspconfig.overrideAttrs(_: {
            dependencies = [ ltex-ls neodev-nvim SchemaStore-nvim ];
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
