{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "luatab-nvim";
  version   = "master";
  src       = fetchFromGitHub {
    owner  = "alvarosevilla95";
    repo   = "luatab.nvim";
    rev    = version;
    sha256 = "17yf4rmyi4ci3nk0bvva28hlvi1d86pk7fk13pw1c9fglvjf6cmw";
  };
}
