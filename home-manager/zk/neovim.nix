{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "zk-nvim";
  version = "main";
  src     = fetchFromGitHub {
    owner  = "mickael-menu";
    repo   = pname;
    rev    = version;
    sha256 = "sha256-+M8bhTYoGVDhBquqPBPHWvqPe5rLuKAwZLIUdXiYDBI=";
  };
}
