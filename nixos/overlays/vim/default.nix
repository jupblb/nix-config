{ buildVimPluginFrom2Nix, fetchFromGitHub, vim_configurable, vimPlugins }:

let
  gruvbox-material = buildVimPluginFrom2Nix {
    name = "gruvbox-material";
    src  = fetchFromGitHub {
      owner  = "sainnhe";
      repo   = "gruvbox-material";
      rev    = "0a0e6b00f78d7808989143fad77b19a6f3676e0e";
      sha256 = "1a7kvx9jb7nkbbs7rv0x10lzfq1h4sk5l0dljnnps6f31ynnqwxm";
    };
  };
in vim_configurable.customize {
  name                              = "vim";
  vimrcConfig.customRC              = builtins.readFile(./vimrc);
  vimrcConfig.packages.myVimPackage = with vimPlugins; {
    start = [ airline ctrlp easymotion gitgutter gruvbox-material ];
  };
}
