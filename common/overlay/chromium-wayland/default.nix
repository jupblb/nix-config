{ chromium, gtk3, makeWrapper, symlinkJoin, wrapGAppsHook }:

let
  chromium'  = chromium.overrideAttrs(old: {
    buildInputs       = old.buildInputs ++ [ gtk3 ];
    nativeBuildInputs = [ wrapGAppsHook ];
  });
  chromium'' = chromium'.override {
    enableVaapi    = true;
    enableWideVine = true;
  };
in symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "chromium-wayland";
  paths       = [ chromium'' ];
  postBuild   = ''
    wrapProgram $out/bin/chromium \
      --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
  '';
}
