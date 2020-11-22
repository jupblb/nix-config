{ fetchFromGitHub, symlinkJoin }:

let plugin = fetchFromGitHub {
  owner  = "oh-my-fish";
  repo   = "theme-bobthefish";
  rev    = "master";
  sha256 = "1fssb5bqd2d7856gsylf93d28n3rw4rlqkhbg120j5ng27c7v7lq";
};
in symlinkJoin {
  name      = "theme-bobthefish";
  paths     = [ plugin ];
  postBuild = "mkdir $out/conf.d && mv $out/*fish $out/conf.d/";
}

