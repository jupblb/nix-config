{
  bash-language-server, eslint, lib, makeWrapper, neovim, nodejs_latest, npm,
  openjdk11, python-language-server, ripgrep, symlinkJoin, vimPlugins,
  writeScriptBin
}:

let
  neovim' = neovim.override {
    configure   = {
      customRC = builtins.readFile(./init.vim);

      plug.plugins = with vimPlugins; [
        coc-nvim
        denite

        airline
        coc-eslint
        coc-java
        coc-json
        coc-metals
        coc-python
#       coc-rust-analyzer
        coc-tsserver
        easymotion
        fugitive
        goyo
        gruvbox-community
        vim-devicons
        vim-nix
        vim-signify
        vim-startify
      ];
    };

    withNodeJs  = true;
    withPython  = false;
    withPython3 = true;
    withRuby    = false;
  };
in symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "nvim";
  paths       = [ neovim' ];
  postBuild   = ''
    wrapProgram "$out/bin/nvim" \
      --prefix PATH : ${lib.makeBinPath[
        bash-language-server
        eslint
        nodejs_latest npm
        openjdk11
        python-language-server
        ripgrep
      ]} \
      --set JAVA_HOME ${openjdk11}/lib/openjdk

    ln -sfn $out/bin/nvim $out/bin/vim
  '';
}
