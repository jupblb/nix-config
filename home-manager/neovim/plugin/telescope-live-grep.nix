{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "telescope-live-grep-args-nvim";
  version   = "master";
  src       = fetchFromGitHub {
    owner  = "nvim-telescope";
    repo   = "telescope-live-grep-args.nvim";
    rev    = version;
    sha256 = "sha256-T5j2qgoDtVkk1uCLjoNeyw4eTu6eLbTXQHUuvHs3Tls=";
  };
}

