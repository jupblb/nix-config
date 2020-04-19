{
  bash-language-server, bat', buildRustPackage, eslint, fd, fetchFromGitHub,
  git', glow', lib, makeWrapper, neovim, nodejs_latest, npm, openjdk11,
  python-language-server, ripgrep, symlinkJoin, vimPlugins, vimUtils
}:

let
  preview-markdown' = vimUtils.buildVimPluginFrom2Nix rec {
    pname   = "preview-markdown";
    version = "2020-04-02";
    src     = fetchFromGitHub {
      owner  = "skanehira";
      repo   = "preview-markdown.vim";
      rev    = "a9520f6a218eb085a0aa1c8f55568e5bbb8b6840";
      sha256 = "1qn0dw1y4xcmaw876v4d3zs30h5gmvv2ppk1niw0hjb9c3nbisy7";
    };
  };

  devicon-lookup'   = buildRustPackage rec {
    cargoSha256 = "048yb45zr589gxvff520wh7cwlhsb3h64zqsjfy85c5y28sv6sas";
    pname       = "devicon-lookup";
    version     = "0.8.0";

    src = fetchFromGitHub {
      owner  = "coreyja";
      repo   = pname;
      rev    = version;
      sha256 = "0v4jc9ckbk6rvhw7apdfr6wp2v8gfx0w13gwpr8ka1sph9n4p3a7";
    };
  };

  neovim'           = neovim.override {
    configure   = {
      customRC = builtins.readFile(./init.vim);

      packages.myVimPackage = with vimPlugins; {
        opt   = [ preview-markdown' ];
        start = [
          coc-nvim

          airline
          coc-eslint
          coc-java
          coc-json
          coc-metals
          coc-python
#         coc-rust-analyzer
          coc-tsserver
          easymotion
          fugitive
          fzf-vim
          goyo
          gruvbox-community
          vim-devicons
          vim-grepper
		  vim-nix
          vim-signify
          vim-startify
        ];
      };
    };

    withNodeJs  = true;
    withPython  = false;
    withPython3 = false;
    withRuby    = false;
  };
in symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "nvim";
  paths       = [ neovim' ];
  postBuild   = ''
    wrapProgram "$out/bin/nvim" \
      --prefix PATH : ${lib.makeBinPath[
        bash-language-server bat'
        devicon-lookup'
        eslint
        fd
        git' glow'
        nodejs_latest npm
        openjdk11
        python-language-server
        ripgrep
      ]} \
      --set JAVA_HOME ${openjdk11}/lib/openjdk

    ln -sfn $out/bin/nvim $out/bin/vim
  '';
}
