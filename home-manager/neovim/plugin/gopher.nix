{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "gopher-nvim";
  version   = "main";
  src       = fetchFromGitHub {
    owner  = "olexsmir";
    repo   = "gopher.nvim";
    rev    = version;
    sha256 = "sha256-NDwQRIrIKYr1m26NXVDZ1gfZNtwMMytqw+364t7BzkE=";
  };
}

