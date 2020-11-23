{ fetchFromGitHub, symlinkJoin, writeTextFile }:

fetchFromGitHub {
  owner  = "Jomik";
  repo   = "fish-gruvbox";
  rev    = "master";
  sha256 = "0hkps4ddz99r7m52lwyzidbalrwvi7h2afpawh9yv6a226pjmck7";
}

