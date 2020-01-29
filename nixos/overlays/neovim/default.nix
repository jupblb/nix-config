{ neovim, vimPlugins }:

neovim.override {
  configure   = {
    customRC = builtins.readFile(../vim/vimrc) + builtins.readFile(./init.vim);
    packages.myVimPackage = with vimPlugins; {
      opt   = [ ];
      start = [
        airline
        ctrlp
        gitgutter
        gruvbox-community
        surround
        vim-startify
      ];
    };
  };
  withPython  = false;
  withPython3 = false;
  withRuby    = false;
}

