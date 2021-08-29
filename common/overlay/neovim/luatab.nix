{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "luatab-nvim";
  src       = fetchFromGitHub {
    owner  = "alvarosevilla95";
    repo   = "luatab.nvim";
    rev    = version;
    sha256 = "1hr8mnc2212hbmhz6mmag4na8nmd99mr4bcy09cyyrndwmwr9gnf";
  };
  version   = "master";
}
