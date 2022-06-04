{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "zk-nvim";
  version = "main";
  src     = fetchFromGitHub {
    owner  = "mickael-menu";
    repo   = pname;
    rev    = version;
    sha256 = "sha256-ida/kZF0X1SqEjAD4ICXtgSB2S/l5aOKs55b2eMdiAQ=";
  };
}
