{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "telescope-vim-bookmarks-nvim";
  src     = fetchFromGitHub {
    owner  = "tom-anders";
    repo   = "telescope-vim-bookmarks.nvim";
    rev    = version;
    sha256 = "0lak83b8y963hv61z2yfi1nyaapvq2hnhpcx7bc6h8v4jzyjis0n";
  };
  version = "main";
}
