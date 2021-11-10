{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "luatab-nvim";
  src       = fetchFromGitHub {
    owner  = "alvarosevilla95";
    repo   = "luatab.nvim";
    rev    = version;
    sha256 = "0iy45hmn6f6dp3pym0yl091kngnrg25hrk5dlm93mj3yxbmgss4r";
  };
  version   = "master";
}
