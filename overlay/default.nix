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
  gtasks-md             = callPackage ./gtasks-md.nix {
    inherit (haskellPackages) pandoc-types;
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
  ripgrep               = symlinkJoin {
    buildInputs = [ makeWrapper ];
    name        = "ripgrep";
    paths       = [ super.ripgrep ];
    postBuild   = ''wrapProgram $out/bin/rg --add-flags "--ignore"'';
  };
  vtclean               = callPackage ./vtclean.nix {};
}
