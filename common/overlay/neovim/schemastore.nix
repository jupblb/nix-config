{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "schemastore-nvim";
  version   = "main";
  src       = fetchFromGitHub {
    owner  = "b0o";
    repo   = "schemastore.nvim";
    rev    = version;
    sha256 = "1h5q33b6bgmj9zf7fm5kbx95gp49jcn8af9rm5jn5bc0b3l7nzls";
  };
}
