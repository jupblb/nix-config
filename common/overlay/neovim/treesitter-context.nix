{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin {
  pname   = "nvim-treesitter-context";
  version = "2020-11-09";
  src     = fetchFromGitHub {
    owner  = "romgrk";
    repo   = "nvim-treesitter-context";
    rev    = "master";
    sha256 = "04mjl32gahaw2xky8yaghmgakiiy47dcjj6k4p793xfcs1kf4bsh";
  };
}

