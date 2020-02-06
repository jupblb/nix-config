{ neovim, vimPlugins }:

neovim.override {
  configure   = {
    customRC = builtins.readFile(../vim/vimrc) + builtins.readFile(./init.vim);

    packages.myVimPackage = with vimPlugins; {
      opt   = [ ];
      start = [
        airline
        ctrlp
#       coc-json
#       coc-metals
        coc-nvim
        easymotion
        fugitive
        gitgutter
        goyo
        gruvbox-community
        limelight-vim
        surround
        vim-startify
      ];
    };
  };

  withNodeJs  = true;
  withPython  = false;
  withPython3 = false;
  withRuby    = false;
}

