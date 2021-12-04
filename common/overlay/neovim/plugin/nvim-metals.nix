{ fetchFromGitHub, plenary-nvim, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild    = true;
  dependencies = [ plenary-nvim ];
  pname        = "nvim-metals";
  version      = "main";
  src          = fetchFromGitHub {
    owner  = "scalameta";
    repo   = pname;
    rev    = version;
    sha256 = "16v2bybicisw0z65j2lphxpbj7w1rzppqmbfjz2b2hrq98b2d87s";
  };
}
