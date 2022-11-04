{ fetchFromGitLab, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "nvim-pqf";
  version = "main";
  src     = fetchFromGitLab {
    owner  = "yorickpeterse";
    repo   = pname;
    rev    = version;
    sha256 = "sha256-5boyx2km06uVP9gZlBWAL8EqiINHCBbQmUzomRTc27A=";
  };
}
