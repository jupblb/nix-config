self: super: with super; {
  calibre-web           = callPackage ./calibre-web { inherit (super) calibre-web; };
  google-chrome-wayland = super.google-chrome.override {
    commandLineArgs = super.lib.concatStringsSep " " [
      "--disable-features=WaylandFractionalScaleV1"
      "--enable-features=UseOzonePlatform" "--ozone-platform=wayland"
    ];
  };
  pragmata-pro          = callPackage ./pragmata-pro {};
  nvidia-offload        = callPackage ./nvidia-offload {};
  vtclean               = callPackage ./vtclean.nix {};
}
