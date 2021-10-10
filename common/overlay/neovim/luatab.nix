{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "luatab-nvim";
  src       = fetchFromGitHub {
    owner  = "alvarosevilla95";
    repo   = "luatab.nvim";
    rev    = version;
    sha256 = "13w4ryqsl3lxxxcrb2dyc0h9kql4cmx0hbhxingrc1cncwgldnj9";
  };
  version   = "master";
}
