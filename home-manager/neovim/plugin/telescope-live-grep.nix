{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "telescope-live-grep-args-nvim";
  version   = "master";
  src       = fetchFromGitHub {
    owner  = "nvim-telescope";
    repo   = "telescope-live-grep-args.nvim";
    rev    = version;
    sha256 = "sha256-RgGCaAolEWMXJet547ce0oW0+zsxQzXrKn+O9WgV1nk=";
  };
}

