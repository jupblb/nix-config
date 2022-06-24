{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "gopher-nvim";
  version   = "main";
  src       = fetchFromGitHub {
    owner  = "olexsmir";
    repo   = "gopher.nvim";
    rev    = version;
    sha256 = "sha256-pRTPoUaMHpAAcnIv6jtxR035XiGYT6fnq1r2oKNFrao=";
  };
}

