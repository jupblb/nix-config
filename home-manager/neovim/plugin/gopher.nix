{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "gopher-nvim";
  version   = "main";
  src       = fetchFromGitHub {
    owner  = "olexsmir";
    repo   = "gopher.nvim";
    rev    = version;
    sha256 = "sha256-aSUCj9H7W8lKrKS18/I0SLIAqOpO8Zten2VPUU3CT5E=";
  };
}

