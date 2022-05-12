{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "telescope-luasnip-nvim";
  version = "master";
  src     = fetchFromGitHub {
    owner  = "benfowler";
    repo   = "telescope-luasnip.nvim";
    rev    = version;
    sha256 = "sha256-I+UyrxC2WX3mupJm6Rf1NHVw+DoRgYRbsFoAEUIssGk=";
  };
}

