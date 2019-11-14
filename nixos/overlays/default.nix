self: pkgs:

let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
in { 
  all-hies'         = all-hies.selection { selector = p: p; };
  diff-so-fancy'    = pkgs.gitAndTools.diff-so-fancy;
  idea-ultimate'    = pkgs.jetbrains.idea-ultimate.override { jdk = pkgs.jetbrains.jdk; };
  redshift-wayland' = pkgs.callPackage ./redshift-wayland {
    inherit (pkgs.python3Packages) python pygobject3 pyxdg wrapPython;
    geoclue = pkgs.geoclue2;
  };
  sbt'              = pkgs.sbt.override { jre = pkgs.graalvm8; };
  vaapiIntel'       = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  vim'              = pkgs.callPackage ./vim { inherit (pkgs.vimUtils) buildVimPluginFrom2Nix; }; 
}
