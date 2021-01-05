{ fetchFromGitHub, symlinkJoin }:

let plugin = fetchFromGitHub {
  owner  = "oh-my-fish";
  repo   = "theme-bobthefish";
  rev    = "master";
  sha256 = "00by33xa9rpxn1rxa10pvk0n7c8ylmlib550ygqkcxrzh05m72bw";
};
in symlinkJoin {
  name      = "theme-bobthefish";
  paths     = [ plugin ];
  postBuild = "mkdir $out/conf.d && mv $out/*fish $out/conf.d/";
}

