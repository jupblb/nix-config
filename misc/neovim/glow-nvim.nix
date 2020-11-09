{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin {
  pname   = "glow-nvim";
  version = "2020-10-12";
  src     = fetchFromGitHub {
    owner  = "npxbr";
    repo   = "glow.nvim";
    rev    = "master";
    sha256 = "0qkvxly52qdxw77mlrwzrjp8i6smzmsd6k4pd7qqq2w8s8y8rda3";
  };
}
