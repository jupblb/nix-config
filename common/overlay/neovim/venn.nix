{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "venn-nvim";
  version   = "main";
  src       = fetchFromGitHub {
    owner  = "jbyuki";
    repo   = "venn.nvim";
    rev    = version;
    sha256 = "1hr8mnc2212hbmhz6mmag4na8nmd99mr4bcy09cyyrndwmwr9gnf";
  };
}
