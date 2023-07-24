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
  mkalias               = super.rustPlatform.buildRustPackage rec {
    pname = "mkalias";
    version = "0.3.2";
    buildInputs = with super.darwin.apple_sdk.frameworks; [ CoreFoundation ];
    src = super.fetchFromGitHub {
      owner = "reckenrode";
      repo  = pname;
      rev   = "v${version}";
      hash  = "sha256-tL3C/b2BPOGQpV287wECDCDWmKwwPvezAAN3qz7N07M=";
    };
    cargoHash = "sha256-RfKVmiFfFzIp//fbIcFce4T1cQPIFuEAw7Zmnl1Ic84=";

  };
  nvidia-offload        = callPackage ./nvidia-offload {};
  vtclean               = callPackage ./vtclean.nix {};
}
