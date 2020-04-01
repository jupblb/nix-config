self: pkgs: { 
  ammonite'         = pkgs.callPackage ./ammonite { };
  bat'              = pkgs.callPackage ./bat { };
  ferdi'            = pkgs.callPackage ./ferdi { };
  git'              = pkgs.callPackage ./git {
    inherit (pkgs.gitAndTools) diff-so-fancy;
  };
  i3'               = pkgs.callPackage ./i3 {
    inherit (pkgs.gnome3) gnome-screenshot;
  };
  i3status'         = pkgs.callPackage ./i3status { };
  idea-ultimate'    = pkgs.callPackage ./idea { };
  kitty'            = pkgs.callPackage ./kitty { };
  neovim'           = pkgs.callPackage ./neovim {
    inherit (pkgs.nodePackages) bash-language-server;
    inherit (pkgs.python3Packages) python-language-server;
    inherit (pkgs.rustPlatform) buildRustPackage;
  };
  ranger'           = pkgs.callPackage ./ranger { };
  redshift-wayland' = pkgs.callPackage ./redshift-wayland {
    inherit (pkgs.python3Packages) pygobject3 python pyxdg wrapPython;
  };
  sbt'              = pkgs.callPackage ./sbt { };
  sway'             = pkgs.callPackage ./sway { };
  vaapiIntel'       = pkgs.vaapiIntel.override { enableHybridCodec = true; };
}
