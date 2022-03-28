{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname     = "cmp-nvim-lsp-signature-help";
  version   = "main";
  src       = fetchFromGitHub {
    owner  = "hrsh7th";
    repo   = pname;
    rev    = version;
    sha256 = "026qsr7rssb9g7l66wjk0m2xrbkmghl5px4w4m1p6vf6lyy5jfjs";
  };
}
