self: pkgs: with pkgs; { 
  ammonite'      = callPackage ./ammonite { };
  ferdi'         = callPackage ./ferdi { };
  git'           = callPackage ./git { inherit (gitAndTools) diff-so-fancy; };
  glow'          = callPackage ./glow { };
  i3status'      = callPackage ./i3status { };
  idea-ultimate' = callPackage ./idea { inherit (jetbrains) idea-ultimate jdk; };
  neovim'        = callPackage ./neovim {
    inherit (nodePackages) bash-language-server eslint npm;
    inherit (python3Packages) python-language-server;
    inherit (rustPlatform) buildRustPackage;
  };
  ranger'        = callPackage ./ranger { };
  sway'          = callPackage ./sway { };
  vaapiIntel'    = vaapiIntel.override { enableHybridCodec = true; };
  wlroots'       = callPackage ./wlroots { };
  xwayland'      = callPackage ./xwayland { };
}
