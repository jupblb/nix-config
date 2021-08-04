{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname     = "zen-mode-nvim";
  version   = "main";
  src       = fetchFromGitHub {
    owner  = "folke";
    repo   = "zen-mode.nvim";
    rev    = version;
    sha256 = "0daj94v8ipqqi8v2rs2dx0z2dk14v7r0ggcmbh81ws73r5drlc3z";
  };
}
