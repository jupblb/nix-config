{
  bash-language-server, fetchFromGitHub, lib, makeWrapper, neovim, openjdk11,
  ripgrep, symlinkJoin, vimPlugins, vimUtils
}:

let
  coc-nvim' = vimUtils.buildVimPluginFrom2Nix rec {
    pname = "coc-nvim";
    version = "0.0.77";
    src = fetchFromGitHub {
      owner = "neoclide";
      repo = "coc.nvim";
      rev = "78af80302de9ee96237afcc4f290ff756cbc41b8";
      sha256 = "1nx8hn5vb82qcykwzjdpd4sh1vsc8nm5068qmdf7sjw1rldn5hkb";
    };
  };
  neovim' = neovim.override {
    configure   = {
      customRC = builtins.readFile(./init.vim);

      packages.myVimPackage = with vimPlugins; {
        opt   = [ ];
        start = [
          airline
          ctrlp
#         coc-java
#         coc-json
#         coc-metals
          coc-nvim'
#         coc-rust-analyzer
          easymotion
          fugitive
          goyo
          gruvbox-community
          surround
          vim-grepper
          vim-nix
          vim-signify
          vim-startify
        ];
      };
    };

    vimAlias = true;
  
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
        bash-language-server openjdk11 ripgrep
      ]} \
      --set JAVA_HOME ${openjdk11}/lib/openjdk

    ln -sfn $out/bin/nvim $out/bin/vim
  '';
}
