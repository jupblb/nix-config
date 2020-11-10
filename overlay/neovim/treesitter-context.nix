{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin {
  pname   = "nvim-treesitter-context";
  version = "2020-11-09";
  src     = fetchFromGitHub {
    owner  = "romgrk";
    repo   = "nvim-treesitter-context";
    rev    = "master";
    sha256 = "0h3lc1i0kppjaq9iha7wp3wc0103h6r8c7s0ih7xsxpdl16rp5rh";
  };
}

