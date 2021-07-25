{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "luatab-nvim";
  version   = "master";
  src       = fetchFromGitHub {
    owner  = "alvarosevilla95";
    repo   = "luatab.nvim";
    rev    = version;
    sha256 = "1g2zam5r894p7hrn60k52z82l9djn9rji34dajp0ni4xadd7nckb";
  };
}
