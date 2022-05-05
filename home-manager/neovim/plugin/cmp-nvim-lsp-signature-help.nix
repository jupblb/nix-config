{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "cmp-nvim-lsp-signature-help";
  version = "main";
  src     = fetchFromGitHub {
    owner  = "hrsh7th";
    repo   = pname;
    rev    = version;
    sha256 = "1k61aw9mp012h625jqrf311vnsm2rg27k08lxa4nv8kp6nk7il29";
  };
}
