{
  bash-language-server, bat', buildRustPackage, fd, fetchFromGitHub, git', glow,
  lib, makeWrapper, neovim, openjdk11, python-language-server, ripgrep,
  symlinkJoin, vimPlugins, vimUtils
}:

let
  coc-nvim'          = vimUtils.buildVimPluginFrom2Nix rec {
    pname   = "coc-nvim";
    version = "0.0.77";
    src     = fetchFromGitHub {
      owner  = "neoclide";
      repo   = "coc.nvim";
      rev    = "78af80302de9ee96237afcc4f290ff756cbc41b8";
      sha256 = "1nx8hn5vb82qcykwzjdpd4sh1vsc8nm5068qmdf7sjw1rldn5hkb";
    };
  };
  gruvbox'           = vimUtils.buildVimPluginFrom2Nix rec {
    pname   = "gruvbox-community";
    version = "2020-03-28";
    src     = fetchFromGitHub {
      owner   = "gruvbox-community";
      repo    = "gruvbox";
      rev     = "f5711c15480b83378bde13306fa997057c0c81cd";
      sha256  = "0vx289a7av31dxm58c6kmfdnsrwnq1rzj5rwci2pqjdac8ds2qm0";
    };
  };
  preview-markdown'  = vimUtils.buildVimPluginFrom2Nix rec {
    pname   = "preview-markdown";
    version = "2020-03-28";
    src     = fetchFromGitHub {
      owner  = "skanehira";
      repo   = "preview-markdown.vim";
      rev    = "2197aa6bf46b9f0b02c5b006512da2b05430e85d";
      sha256 = "03s8dmxz25wdmznljfvh668z8gva2g0mkfn70dz5hsf0vi4q8p9p";
    };
  };

  devicon-lookup' = buildRustPackage rec {
    cargoSha256 = "1w8dj0si8glcdxg66pnbil2zlwhb009wiq6p205a0q9hiqisid4l";
    pname       = "devicon-lookup";
    version     = "0.7.1";

    src = fetchFromGitHub {
      owner  = "coreyja";
      repo   = pname;
      rev    = version;
      sha256 = "1c15pl9f6civpya7kjxc87s5yffxghgi41zmaa5n3cqchsfizprs";
    };
  };
  glow'           = symlinkJoin {
    buildInputs = [ makeWrapper ];
    name        = "glow";
    paths       = [ glow ];
    postBuild   = ''wrapProgram "$out/bin/glow" --add-flags "-s light"'';
  };
  neovim'         = neovim.override {
    configure   = {
      customRC = builtins.readFile(./init.vim);

      packages.myVimPackage = with vimPlugins; {
        opt   = [ preview-markdown' ];
        start = [
          airline
          coc-java
#         coc-json
#         coc-metals
          coc-nvim'
#         coc-python
#         coc-rust-analyzer
          easymotion
          fugitive
          fzf-vim
          goyo
          gruvbox'
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
        fd
        git' glow'
        openjdk11
        python-language-server
        ripgrep
      ]} \
      --set JAVA_HOME ${openjdk11}/lib/openjdk

    ln -sfn $out/bin/nvim $out/bin/vim
  '';
}
