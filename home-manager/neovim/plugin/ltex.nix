{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "ltex-ls-nvim";
  version = "main";
  src     = fetchFromGitHub {
    owner  = "vigoux";
    repo   = "ltex-ls.nvim";
    rev    = version;
    sha256 = "sha256-jY3ALr6h88xnWN2QdKe3R0vvRcSNhFWDW56b2NvnTCs=";
  };
}
