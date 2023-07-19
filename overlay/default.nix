self: super: with super; {
  calibre-web           = callPackage ./calibre-web { inherit (super) calibre-web; };
  git-tidy              = callPackage ./git-tidy.nix {
    inherit (super.rustPlatform) buildRustPackage;
  };
  google-chrome-wayland = super.google-chrome.override {
    commandLineArgs = super.lib.concatStringsSep " " [
      "--disable-features=WaylandFractionalScaleV1"
      "--enable-features=UseOzonePlatform" "--ozone-platform=wayland"
    ];
  };
  jdt-language-server   = super.jdt-language-server.overrideAttrs(old: {
    installPhase = old.installPhase + ''
      cp $out/bin/jdt-language-server $out/bin/jdtls
    '';
  });
  nvidia-offload        = callPackage ./nvidia-offload {};
  vtclean               = callPackage ./vtclean.nix {};
}
