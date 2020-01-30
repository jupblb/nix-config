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
        fugitive
        gitgutter
        gruvbox-community
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

