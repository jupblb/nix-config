{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname     = "telescope-coc-nvim";
  version   = "master";
  src       = fetchFromGitHub {
    owner  = "fannheyward";
    repo   = "telescope-coc.nvim";
    rev    = version;
    sha256 = "15pzikwpzrdwrngyyrqg73am3k9p8m43hdpaxf5f3j65xqr98ivp";
  };
}
