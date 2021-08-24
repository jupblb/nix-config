{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname     = "vim-bookmarks";
  version   = "master";
  src       = fetchFromGitHub {
    owner  = "MattesGroeger";
    repo   = pname;
    rev    = version;
    sha256 = "1w8g9jvyi765sp2icjb6c20yn0y6w69zfyh37a367aqk7r76nbk5";
  };
}
