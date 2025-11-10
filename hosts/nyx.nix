{ config, lib, pkgs, ... }: {
  fonts.fontconfig = { enable = true; };

  home = {
    homeDirectory    = "/Users/${config.home.username}";
    packages         =
      let iosevka = pkgs.iosevka-bin.override { variant = "SGr-Iosevka"; };
      in [ iosevka ];
    sessionVariables = {
      CARGOHOME = "${config.xdg.dataHome}/cargo";
      GOPATH    = "${config.xdg.dataHome}/go";
    };
    stateVersion     = "25.05";
  };

  imports = [
    ../home-manager
    ../home-manager/fish
    ../home-manager/kitty.nix
    ../home-manager/lf
    ../home-manager/neovim
  ];

  programs = {
    home-manager = { enable = true; };

    git = {
      # Not supported by Apple default git binary
      extraConfig = { core.fsmonitor = lib.mkForce false; };
    };

    kitty = {
      font        = { size = lib.mkForce 14; };
      keybindings = { "cmd+t" = "new_tab_with_cwd"; };
      package     = pkgs.hello;
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
