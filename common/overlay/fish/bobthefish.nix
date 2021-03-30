{ fetchFromGitHub, symlinkJoin }:

let plugin = fetchFromGitHub {
  owner  = "oh-my-fish";
  repo   = "theme-bobthefish";
  rev    = "master";
  sha256 = "06whihwk7cpyi3bxvvh3qqbd5560rknm88psrajvj7308slf0jfd";
};
in symlinkJoin {
  name      = "theme-bobthefish";
  paths     = [ plugin ];
  postBuild = "mv $out/functions $out/conf.d";
}
