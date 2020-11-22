{ fetchFromGitHub, symlinkJoin, writeTextFile }:

let
  init   = writeTextFile {
    name = "gruvbox_init_fish";
    text = "if status --is-interactive; theme_gruvbox light hard; end";
  };
  plugin = fetchFromGitHub {
    owner  = "Jomik";
    repo   = "fish-gruvbox";
    rev    = "master";
    sha256 = "0hkps4ddz99r7m52lwyzidbalrwvi7h2afpawh9yv6a226pjmck7";
  };
in symlinkJoin {
  name      = "fish-gruvbox";
  paths     = [ plugin ];
  postBuild = "mkdir $out/conf.d && ln -s ${init} $out/conf.d/init.fish";
}

