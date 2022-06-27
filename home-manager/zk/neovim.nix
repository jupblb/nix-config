{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "zk-nvim";
  version = "main";
  src     = fetchFromGitHub {
    owner  = "mickael-menu";
    repo   = pname;
    rev    = version;
    sha256 = "sha256-F4oRpCdYWmuF7muao4xj6DNwXdVFI+aSD2Dy+tYsuS8=";
  };
}
