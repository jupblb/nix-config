{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "yaml-companion-nvim";
  version   = "main";
  src       = fetchFromGitHub {
    owner  = "someone-stole-my-name";
    repo   = "yaml-companion.nvim";
    rev    = version;
    sha256 = "sha256-2lZDWyAw6O0eI89FQIgRK4ZhrOqCtFX5Io9JkQ1+Jgk=";
  };
}

