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
  mkalias               = callPackage ./mkalias.nix {
    inherit (darwin) apple_sdk;
    inherit (rustPlatform) buildRustPackage;
  };
  steam-run-url         = pkgs.writeShellApplication {
    name = "steam-run-url";
    text = ''
      ${coreutils}/bin/echo "$1" \
        > "/run/user/$(${coreutils}/bin/id --user)/steam-run-url.fifo"
    '';
  };
  vtclean               = callPackage ./vtclean.nix {};
}
