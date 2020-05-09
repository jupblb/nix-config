{
  bash-language-server, eslint, fetchFromGitHub, lib, neovim, nodejs_latest,
  npm, openjdk11, python-language-server, ranger', ripgrep, vimPlugins, vimUtils
}:

let
  vim-ranger' = vimUtils.buildVimPluginFrom2Nix {
    pname   = "ranger-vim";
    version = "2020-05-08";
    src     = fetchFromGitHub {
      owner  = "francoiscabrol";
      repo   = "ranger.vim";
      rev    = "91e82debdf566dfaf47df3aef0a5fd823cedf41c";
      sha256 = "0i2d88yyfjv4gn3zn7jzv5pf94vzllvxmnmi3hdjddrhl2xppsza";
    };
  };
in neovim.override {
  configure   = {
    customRC = builtins.readFile(./init.vim);

    plug.plugins = with vimPlugins; [
      coc-nvim
      denite

      airline
      bclose-vim
      coc-eslint
      coc-java
      coc-json
      coc-metals
      coc-python
#     coc-rust-analyzer
      coc-tsserver
      easymotion
      fugitive
      goyo
      gruvbox-community
      vim-devicons
      vim-nix
      vim-ranger'
      vim-signify
      vim-startify
    ];
  };

  extraMakeWrapperArgs = ''
    --prefix PATH : ${lib.makeBinPath[
      bash-language-server
      eslint
      nodejs_latest npm
      openjdk11
      python-language-server
      ranger' ripgrep
    ]} \
    --set JAVA_HOME ${openjdk11}/lib/openjdk
  '';

  vimAlias = true;

  withNodeJs  = true;
  withPython  = false;
  withPython3 = true;
  withRuby    = false;
}
