{ config, pkgs, ... }: {
  home.sessionVariables = {
    JDTLS_HOME = "${pkgs.jdt-language-server}/share/java";
    WORKSPACE  = "${config.home.homeDirectory}/Workspace";
  };

  programs.neovim = {
    extraPackages =
      let
        default      = with pkgs; [
          buildifier cargo coursier fish gopls jdt-language-server jq openjdk
          pandoc rnix-lsp rust-analyzer rustc shellcheck shfmt statix
          sumneko-lua-language-server
        ];
        nodePackages = with pkgs.nodePackages; [
          bash-language-server dockerfile-language-server-nodejs
          markdownlint-cli pyright vscode-json-languageserver
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
      } {
        config = "luafile ${toString ./config/metals.lua}";
        plugin = nvim-metals;
    } ];
  };
}
