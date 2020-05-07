self: pkgs: with pkgs; { 
  ammonite'       = callPackage ./ammonite { };
  ferdi'          = callPackage ./ferdi { };
  i3status'       = callPackage ./i3status { };
  idea-ultimate'  = callPackage ./idea-ultimate {
    inherit (jetbrains) idea-ultimate jdk;
  };
  lsd'            = callPackage ./lsd { };
  neovim'         = callPackage ./neovim {
    inherit (nodePackages) bash-language-server eslint npm;
    inherit (python3Packages) python-language-server;
  };
  ranger'         = callPackage ./ranger { };
  scp-speed-test' = callPackage ./scp-speed-test { };
  sway'           = callPackage ./sway { };
  wlroots'        = callPackage ./wlroots { };
  xwayland'       = callPackage ./xwayland { };
}
