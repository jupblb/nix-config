{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname     = "venn-nvim";
  version   = "main";
  src       = fetchFromGitHub {
    owner  = "jbyuki";
    repo   = "venn.nvim";
    rev    = version;
    sha256 = "1f3kw0lyny2kzgz0m2pff0fjl39gz4z8yap80k1js573axn9nl2j";
  };
}
