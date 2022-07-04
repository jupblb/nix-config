{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "gopher-nvim";
  version   = "main";
  src       = fetchFromGitHub {
    owner  = "olexsmir";
    repo   = "gopher.nvim";
    rev    = version;
    sha256 = "sha256-bq8jTMWmFn+BL3yU6PRHqsvSk4K+96gE+6qgklphymw=";
  };
}

