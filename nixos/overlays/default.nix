self: pkgs:

let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
in { 
  all-hies'         = all-hies.selection { selector = p: p; };
  diff-so-fancy'    = pkgs.gitAndTools.diff-so-fancy;
  gnome-screenshot' = pkgs.gnome3.gnome-screenshot;
  idea-ultimate'    = pkgs.jetbrains.idea-ultimate.overrideAttrs (old: rec {
    name    = "idea-ultimate-${version}";
    version = "2019.3";
    src     = pkgs.buildPackages.fetchurl {
      url    = "https://download.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "0jxkx8xq1a73mrvzjaniapiznwr77hli9srwgkxa6zsq2kmix6vk";
    };
  });
  sbt'              = pkgs.sbt.override { jre = pkgs.graalvm8; };
  vaapiIntel'       = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  vim'              = pkgs.callPackage ./vim { inherit (pkgs.vimUtils) buildVimPluginFrom2Nix; }; 
}
