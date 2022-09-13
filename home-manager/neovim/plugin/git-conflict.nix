{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "git-conflict-nvim";
  version = "main";
  src     = fetchFromGitHub {
    owner  = "akinsho";
    repo   = "git-conflict.nvim";
    rev    = version;
    sha256 = "sha256-SkKZxrHKFpZsqnUlr+ft1wSdMP9l6YMly8f9o4Mb81c=";
  };
}
