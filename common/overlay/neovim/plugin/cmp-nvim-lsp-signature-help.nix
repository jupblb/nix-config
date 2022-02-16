{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname     = "cmp-nvim-lsp-signature-help";
  version   = "main";
  src       = fetchFromGitHub {
    owner  = "hrsh7th";
    repo   = pname;
    rev    = version;
    sha256 = "0ly41w9x7ygi0ii8i9k56g5p2sdxn345rf21rb7asnlck1ahc0r1";
  };
}
