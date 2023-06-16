self: super: with super; {
  calibre-web           = callPackage ./calibre-web { inherit (super) calibre-web; };
  google-chrome-wayland = super.google-chrome.override {
    commandLineArgs = super.lib.concatStringsSep " " [
      "--disable-features=WaylandFractionalScaleV1"
      "--enable-features=UseOzonePlatform" "--ozone-platform=wayland"
    ];
  };
  iosevka-term          = super.iosevka-bin.override {
    variant = "sgr-iosevka-term";
  };
  iosevka-term-custom   = super.iosevka.override {
    set              = "custom-term";
    privateBuildPlan = {
      export-glyph-names = true;
      family             = "Iosevka Term";
      ligations          = { inherits = "dlig"; };
      spacing            = "term";
    };
  };
  nvidia-offload        = callPackage ./nvidia-offload {};
  vtclean               = callPackage ./vtclean.nix {};
}
