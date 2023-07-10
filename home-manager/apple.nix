{ lib, ... }: {
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
