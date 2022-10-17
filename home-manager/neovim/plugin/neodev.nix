{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "neodev-nvim";
  version = "main";
  src     = fetchFromGitHub {
    owner  = "folke";
    repo   = "neodev.nvim";
    rev    = version;
    sha256 = "sha256-xzj9xDCR4g8TnIA0zWfu2dBFQMcVN0Xvkzf5IYbczIk=";
  };
}
