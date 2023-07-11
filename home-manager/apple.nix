{ lib, ... }: {
  disabledModules = ["targets/darwin/linkapps.nix"];

  home.activation = {
    # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1446696577
    aliasApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        app_folder="Home Manager Apps"
        app_path="$(echo ~/Applications)/$app_folder"
        tmp_path="$(mktemp -dt "$app_folder.XXXXXXXXXX")" || exit 1

        for app in \
          $(find "$newGenPath/home-path/Applications" -type l -exec \
            readlink -f {} \;)
        do
          $DRY_RUN_CMD /usr/bin/osascript \
            -e "tell app \"Finder\"" \
            -e "make new alias file at POSIX file \"$tmp_path\" \
                                    to POSIX file \"$app\"" \
            -e "set name of result to \"$(basename $app)\"" \
            -e "end tell"
        done

        $DRY_RUN_CMD [ -e "$app_path" ] && rm -r "$app_path"
        $DRY_RUN_CMD mv "$tmp_path" "$app_path"
    '';
  };

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
