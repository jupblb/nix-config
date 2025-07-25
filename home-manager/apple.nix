# Additional config
# - https://apple.stackexchange.com/a/214349

{ lib, ... }: {
  # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1466965161
  imports =
    let
      mac-app-util-src = builtins.fetchTarball
        "https://github.com/hraban/mac-app-util/archive/master.tar.gz";
      mac-app-util-hm  = (import mac-app-util-src {}).homeManagerModules;
    in [ mac-app-util-hm.default ];

  programs = {
    git = {
      extraConfig = { core.fsmonitor = true; };
    };

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

  targets.darwin.defaults = {
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores     = true;
    };

    "com.apple.dock" = { autohide = true; };

    "com.apple.finder" = { FXRemoveOldTrashItems = true; };

    NSGlobalDomain = {
      AppleLanguages           = [ "en" "pl" ];
      AppleLocale              = "en_US";
      AppleMeasurementUnits    = "Centimeters";
      AppleMetricUnits         = true;
      ApplePressAndHoldEnabled = false;
      AppleTemperatureUnit     = "Celsius";
      KeyRepeat                = 2;

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
