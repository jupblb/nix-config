{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname     = "venn-nvim";
  version   = "main";
  src       = fetchFromGitHub {
    owner  = "jbyuki";
    repo   = "venn.nvim";
    rev    = version;
    sha256 = "0pcxb75rwcxydid81xf8kj9bljkdacm44v1ngr2qxgkh3l3awg5y";
  };
}
