{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "pounce-nvim";
  version   = "master";
  src       = fetchFromGitHub {
    owner  = "rlane";
    repo   = "pounce.nvim";
    rev    = version;
    sha256 = "sha256-tg2zplVKfbNLKCYTmhvJfc0GEh6u1e2T3kgG/ju3PGA=";
  };
}
