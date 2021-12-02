{ fetchFromGitLab, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname     = "nvim-pqf";
  version   = "main";
  src       = fetchFromGitLab {
    owner  = "yorickpeterse";
    repo   = pname;
    rev    = version;
    sha256 = "1rq5lzl5cj7iz5i87fvkai7c87yqy43c58886710fgkc9zmlgmpf";
  };
}
