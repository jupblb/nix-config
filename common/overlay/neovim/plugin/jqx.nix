{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname        = "nvim-jqx";
  version      = "master";
  src          = fetchFromGitHub {
    owner  = "gennaro-tedesco";
    repo   = pname;
    rev    = version;
    sha256 = "1dh4yb6rr593nx8kbhskpbb50l211b9z47rvhxd1n07d31bc0lmc";
  };
}
