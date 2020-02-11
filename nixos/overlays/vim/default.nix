{ buildVimPluginFrom2Nix, fetchFromGitHub, vim_configurable, vimPlugins }:

vim_configurable.customize {
  name                              = "vim";
  vimrcConfig.customRC              = ''
    ${builtins.readFile(./vimrc)}
    " Set custom location for netrw and viminfo
    let g:netrw_home='~/.cache/vim_netrwhist'
    set viminfo+='1000,n~/.cache/viminfo
  '';
  vimrcConfig.packages.myVimPackage = with vimPlugins; {
    start = [ airline ctrlp gitgutter gruvbox-community ];
  };
}
