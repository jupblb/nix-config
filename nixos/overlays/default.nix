self: pkgs:

let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
in { 
  all-hies'         = all-hies.selection { selector = p: { inherit (p) ghc882 ghc865 ghc844; }; };
  ammonite'         = pkgs.callPackage ./ammonite { };
  fish'             = pkgs.callPackage ./fish { };
  git'              = pkgs.callPackage ./git { inherit (pkgs.gitAndTools) diff-so-fancy; };
  i3'               = pkgs.callPackage ./i3 { inherit (pkgs.gnome3) gnome-screenshot; };
  i3status'         = pkgs.callPackage ./i3status { };
  idea-ultimate'    = pkgs.callPackage ./idea { };
  kitty'            = pkgs.callPackage ./kitty { };
  neovim'           = pkgs.callPackage ./neovim { inherit (pkgs.nodePackages) bash-language-server; };
  redshift'         = pkgs.callPackage ./redshift { inherit (pkgs.python3Packages) python pygobject3 pyxdg wrapPython; };
  sbt'              = pkgs.callPackage ./sbt { };
  sway'             = pkgs.callPackage ./sway { };
  sway-scaled'      = pkgs.callPackage ./sway { withScaling = true; };
  vaapiIntel'       = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  vim'              = pkgs.callPackage ./vim { inherit (pkgs.vimUtils) buildVimPluginFrom2Nix; }; 
}
