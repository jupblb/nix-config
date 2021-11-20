{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname     = "telescope-lsp-handlers-nvim";
  src       = fetchFromGitHub {
    owner  = "gbrlsnchs";
    repo   = "telescope-lsp-handlers.nvim";
    rev    = version;
    sha256 = "1x51mlj1c3cwmcjqssh89049q91423jxm3rv8s25pcw493zb2x6b";
  };
  version   = "trunk";
}
