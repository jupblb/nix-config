{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname     = "telescope-tele-tabby-nvim";
  version   = "main";
  src       = fetchFromGitHub {
    owner  = "TC72";
    repo   = "telescope-tele-tabby.nvim";
    rev    = version;
    sha256 = "1zg9vbzvxx1xxw3fdkm4zjhr33shmhmj05yb6hq096p5zl7qk1h8";
  };
}
