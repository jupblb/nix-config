{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname     = "nabla-nvim";
  version   = "master";
  src       = fetchFromGitHub {
    owner  = "jbyuki";
    repo   = "nabla.nvim";
    rev    = version;
    sha256 = "1iir52nkpmbd51f7yfblbssfazvcsrbbzpqb1dfyzfws72bld13x";
  };
}
