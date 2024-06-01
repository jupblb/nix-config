{ config, lib, pkgs, ... }: {
  # The default solution doesn't work with Spotlight
  disabledModules = [ "targets/darwin/linkapps.nix" ];

  # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1466965161
  home.activation = {
    aliasApplications   =
      let apps = pkgs.buildEnv {
        name        = "home-manager-applications";
        paths       = config.home.packages;
        pathsToLink = "/Applications";
      };
      in lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        echo "Linking Home Manager applications..." 2>&1
        app_path="$HOME/Applications/Home Manager Apps"
        tmp_path="$(mktemp -dt "home-manager-applications.XXXXXXXXXX")" || exit 1

        ${pkgs.fd}/bin/fd \
          -t l -d 1 . ${apps}/Applications \
          -x $DRY_RUN_CMD ${pkgs.mkalias}/bin/mkalias -L {} "$tmp_path/{/}"

        $DRY_RUN_CMD rm -rf "$app_path"
        $DRY_RUN_CMD mv "$tmp_path" "$app_path"
      '';
    disablePressAndHold =
      "$DRY_RUN_CMD /usr/bin/defaults write -g ApplePressAndHoldEnabled -bool false";
  };

  programs.kitty = {
    font        = { size = lib.mkForce 14; };
    keybindings = { "cmd+t" = "new_tab_with_cwd"; };
    settings    = {
      hide_window_decorations            = lib.mkForce "no";
      macos_option_as_alt                = "left";
      macos_quit_when_last_window_closed = "yes";
    };
  };

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
