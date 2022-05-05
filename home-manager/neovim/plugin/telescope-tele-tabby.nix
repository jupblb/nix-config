{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "telescope-tele-tabby-nvim";
  version = "main";
  src     = fetchFromGitHub {
    owner  = "TC72";
    repo   = "telescope-tele-tabby.nvim";
    rev    = version;
    sha256 = "0bnndfw0qks5jpr1w9ddafm90wl5xnxvpciai4pi5gqgirnasyh2";
  };
}
