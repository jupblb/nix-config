self: pkgs:

let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
in { 
  all-hies'         = all-hies.selection { selector = p: p; };
  ammonite'         = pkgs.callPackage ./ammonite { };
  i3'               = pkgs.callPackage ./i3 { };
  i3status'         = pkgs.callPackage ./i3status { };
  idea-ultimate'    = pkgs.callPackage ./idea { };
  kitty'            = pkgs.callPackage ./kitty { };
  neovim'           = pkgs.callPackage ./neovim { inherit (pkgs.nodePackages) bash-language-server; };
  redshift'         = pkgs.callPackage ./redshift { inherit (pkgs.python3Packages) python pygobject3 pyxdg wrapPython; };
  sbt'              = pkgs.callPackage ./sbt { };
  vaapiIntel'       = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  vim'              = pkgs.callPackage ./vim { inherit (pkgs.vimUtils) buildVimPluginFrom2Nix; }; 
}
