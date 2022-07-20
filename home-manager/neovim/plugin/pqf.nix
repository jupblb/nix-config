{ fetchFromGitLab, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "nvim-pqf";
  version = "main";
  src     = fetchFromGitLab {
    owner  = "yorickpeterse";
    repo   = pname;
    rev    = version;
    sha256 = "sha256-92svyhw9ymDsikgNXZi3VAXQIJ1EIEAmtHMNpVj/CQg=";
  };
}
