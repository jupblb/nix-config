{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname     = "telescope-coc-nvim";
  version   = "master";
  src       = fetchFromGitHub {
    owner  = "fannheyward";
    repo   = "telescope-coc.nvim";
    rev    = version;
    sha256 = "0i2g168q57pfbm63idl054sdbflkgd8a754pvk0q9w7w1mzpql2q";
  };
}
