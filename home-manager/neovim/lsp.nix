{ lib, pkgs, ... }: {
  nixpkgs.config.allowUnfreePredicate = pkg: (lib.getName pkg) == "vscode";

  programs = {
    git.ignores = [ ".ltex_ls_cache.json" ];

    neovim = {
      extraPackages =
        let
          default        = with pkgs; [
            black dart fish gomodifytags gopls gotests impl isort jq
            jdt-language-server ltex-ls lua-language-server marksman nil
            pandoc shellcheck shfmt statix
          ];
          latexindent    = pkgs.texlive.latexindent.pkgs;
          nodePackages   = with pkgs.nodePackages; [
            bash-language-server dockerfile-language-server-nodejs eslint
            markdownlint-cli pyright typescript-language-server
            vim-language-server vscode-langservers-extracted
          ];
          nodeAtPackages = [
            pkgs.nodePackages."@prisma/language-server"
            pkgs.nodePackages."@tailwindcss/language-server"
          ];
        in default ++ latexindent ++ nodePackages ++ nodeAtPackages;
      plugins       = with pkgs.vimPlugins; [ {
          config = "source ${toString ./config/fidget.vim}";
          plugin = fidget-nvim;
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
  };

  xdg = {
    configFile = {
      # https://github.com/igorshubovych/markdownlint-cli#configuration
      # https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md
      "markdownlint".source = toString ./config/markdownlint.json;
    };
    dataFile   = {
      # https://dev.languagetool.org/finding-errors-using-n-gram-data.html
      "ngrams/en".source = pkgs.fetchzip {
        url    =
          "https://languagetool.org/download/ngram-data/ngrams-en-20150817.zip";
        sha256 = "sha256-v3Ym6CBJftQCY5FuY6s5ziFvHKAyYD3fTHr99i6N8sE=";
      };
    };
  };
}
