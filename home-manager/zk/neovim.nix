{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "zk-nvim";
  version = "main";
  src     = fetchFromGitHub {
    owner  = "mickael-menu";
    repo   = pname;
    rev    = version;
    sha256 = "sha256-n9mvHT4g+G3sEGDlIrh1nV2AAw9Bj7jZVag8YRe3NQE=";
  };
}
