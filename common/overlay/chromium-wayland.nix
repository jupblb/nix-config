{ chromium, wrapGAppsHook }:

let chromium' = chromium.overrideAttrs(_: {
  nativeBuildInputs = [ wrapGAppsHook ];
});
in chromium'.override {
  commandLineArgs     =
    "--enable-features=UseOzonePlatform --ozone-platform=wayland";
  enableVaapi         = true;
  enableWideVine      = true;
}
