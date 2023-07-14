{ config, lib, pkgs, ... }: {
  # The default solution doesn't work with Spotlight
  disabledModules = ["targets/darwin/linkapps.nix"];

  # https://github.com/nix-community/home-manager/issues/1341#issuecomment-778820334
  home.activation.aliasApplications =
    let apps = pkgs.buildEnv {
      name        = "home-manager-applications";
      paths       = config.home.packages;
      pathsToLink = "/Applications";
    };
    in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      baseDir="${config.home.homeDirectory}/Applications/Home Manager"
      if [ -d "$baseDir" ]; then
        $DRY_RUN_CMD rm -rf "$baseDir"
      fi
      $DRY_RUN_CMD mkdir -p "$baseDir"
      for appFile in ${apps}/Applications/*; do
        target="$baseDir/$(basename "$appFile")"
        $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
        $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
      done
    '';

  programs.kitty = { font.size = lib.mkForce 14; };

  targets.darwin.defaults = {
    NSGlobalDomain = {
      AppleLanguages        = [ "en" "pl" ];
      AppleLocale           = "en_US";
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits      = true;
      AppleTemperatureUnit  = "Celsius";

      NSAutomaticCapitalizationEnabled     = false;
      NSAutomaticDashSubstitutionEnabled   = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled  = false;
      NSAutomaticSpellingCorrectionEnabled = false;

      com.apple.desktopservices = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores     = true;
      };
    };
  };
}
