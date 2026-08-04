{ lib, pkgs, ... }: {
  home.packages = [ (pkgs.iosevka-bin.override { variant = "SGr-Iosevka"; }) ];

  # https://github.com/nix-community/home-manager/issues/7935
  manual = { manpages.enable = false; };

  programs = {
    kitty = {
      font        = { size = lib.mkForce 14; };
      keybindings = { "cmd+t" = "new_tab_with_cwd"; };
      settings    = {
        hide_window_decorations            = lib.mkForce "no";
        macos_option_as_alt                = "left";
        macos_quit_when_last_window_closed = "yes";
      };
    };
  };

  targets.darwin = {
    defaults = {
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores     = true;
      };

      "com.apple.dock" = {
        autohide     = true;
        mru-spaces   = false;
        show-recents = false;
      };

      "com.apple.finder" = { FXRemoveOldTrashItems = true; };

      NSGlobalDomain = {
        AppleLanguages           = [ "en" "pl" ];
        AppleLocale              = "en_US";
        AppleMeasurementUnits    = "Centimeters";
        AppleMetricUnits         = true;
        ApplePressAndHoldEnabled = false;
        AppleTemperatureUnit     = "Celsius";
        KeyRepeat                = 2;
        NSWindowResizeTime       = 0.001;

        NSAutomaticCapitalizationEnabled     = false;
        NSAutomaticDashSubstitutionEnabled   = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled  = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
    };
  };
}
