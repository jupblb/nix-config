{ fetchFromGitHub, vimPlugins, vimUtils }:

vimUtils.buildVimPlugin rec {
  dependencies = with vimPlugins; [ bclose-vim ];
  pname        = "ranger-vim";
  src          = fetchFromGitHub {
    owner  = "francoiscabrol";
    repo   = "ranger.vim";
    rev    = version;
    sha256 = "0i2d88yyfjv4gn3zn7jzv5pf94vzllvxmnmi3hdjddrhl2xppsza";
  };
  version      = "master";
}
