{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname     = "cmp-nvim-lsp-signature-help";
  version   = "main";
  src       = fetchFromGitHub {
    owner  = "hrsh7th";
    repo   = pname;
    rev    = version;
    sha256 = "15f27cz2q2bnsv98mjyvf0j5vx8lidvz2vr10090qv4nwakrhpy6";
  };
}
