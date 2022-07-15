{ config, pkgs, ... }: {
  programs.neovim = {
    extraPackages =
      let
        default      = with pkgs; [
          buildifier cargo fish gomodifytags gopls gotests
          haskell-language-server impl jdt-language-server jq ltex-ls metals
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
        config = "source ${toString ./config/fidget.vim}";
        plugin = fidget-nvim;
      } {
        config = "lua require('lsp_lines').register_lsp_virtual_lines()";
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
        plugin = nvim-lspconfig.overrideAttrs(_: {
          dependencies = [ lua-dev-nvim SchemaStore-nvim ];
        });
      }
      (pkgs.callPackage ./plugin/gopher.nix {})
    ];
  };
}
