{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "zk-nvim";
  version = "main";
  src     = fetchFromGitHub {
    owner  = "mickael-menu";
    repo   = pname;
    rev    = version;
    sha256 = "0kgk9aa85bry9f6njff53z4gy62h2m57bcjwarkls8rd6gq92szz";
  };
}
