{ buildVimPluginFrom2Nix, fetchFromGitHub, vim_configurable, vimPlugins }:
let
  gruvbox-material = buildVimPluginFrom2Nix {
    name = "gruvbox-material";
    src = fetchFromGitHub {
      owner = "sainnhe";
      repo = "gruvbox-material";
      rev = "f4375648cb1bfc548b72bb7ba2c5b9c38ec4684e";
      sha256 = "169zrgjn8imn5s4k4zhz0qc88gv9gkac5yhlcdpwkv329h5g9kn4";
    };
  };
in vim_configurable.customize {
  name                              = "vim";
  vimrcConfig.customRC              = builtins.readFile(./vimrc);
  vimrcConfig.packages.myVimPackage = with vimPlugins; {
    start = [ airline ctrlp easymotion gitgutter gruvbox-material ];
  };
}
