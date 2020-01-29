{ buildVimPluginFrom2Nix, fetchFromGitHub, vim_configurable, vimPlugins }:

vim_configurable.customize {
  name                              = "vim";
  vimrcConfig.customRC              = builtins.readFile(./vimrc);
  vimrcConfig.packages.myVimPackage = with vimPlugins; {
    start = [ airline ctrlp gitgutter gruvbox-community ];
  };
}
