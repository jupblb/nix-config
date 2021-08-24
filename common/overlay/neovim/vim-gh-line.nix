{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "vim-gh-line";
  src     = fetchFromGitHub {
    owner  = "ruanyl";
    repo   = pname;
    rev    = version;
    sha256 = "0pfw8jvmxwhdvjcfypiqk2jlk5plqbigjmykbqs1zvaznc2b7z5v";
  };
  version = "master";
}
