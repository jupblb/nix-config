{ fetchFromGitHub, symlinkJoin }:

fetchFromGitHub {
  owner  = "oh-my-fish";
  repo   = "theme-bobthefish";
  rev    = "master";
  sha256 = "06whihwk7cpyi3bxvvh3qqbd5560rknm88psrajvj7308slf0jfd";
}
