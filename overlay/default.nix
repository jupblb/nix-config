self: super: with super; {
  fortune               = fortune.override({ withOffensive = true; });
  git-tidy              = callPackage ./git-tidy.nix {
    inherit (rustPlatform) buildRustPackage;
  };
  google-chrome-wayland = google-chrome.override {
    commandLineArgs = lib.concatStringsSep " " [
      "--disable-features=WaylandFractionalScaleV1"
      "--enable-features=UseOzonePlatform" "--ozone-platform=wayland"
    ];
  };
  jdt-language-server   = jdt-language-server.overrideAttrs(old: {
    installPhase = old.installPhase + ''
      ln -sfn $out/bin/jdt-language-server $out/bin/jdtls
    '';
  });
  mkalias               = callPackage ./mkalias.nix {
    inherit (darwin) apple_sdk;
    inherit (rustPlatform) buildRustPackage;
  };
  vtclean               = callPackage ./vtclean.nix {};
}
