{ inputs, lib, pkgs, ... }: {
  home = {
    homeDirectory = "/Users/jupblb";
    packages      =
      let iosevka = (pkgs.iosevka-bin.override { variant = "SGr-Iosevka"; });
      in with pkgs; [ bashInteractive iosevka utm ];
    stateVersion  = "26.05";
    username      = "jupblb";
  };

  imports = [
    inputs.mac-app-util.homeManagerModules.default
    ../home-manager
    ../home-manager/fish
    ../home-manager/kitty.nix
    ../home-manager/lf
    ../home-manager/neovim
  ];

  # https://github.com/nix-community/home-manager/issues/7935
  manual = { manpages.enable = false; };

  nixpkgs = {
    config   = { allowUnfree = true; };
    overlays = with inputs.llm-agents.packages.aarch64-darwin;
      [ (_: _: { amp-cli = amp; }) ];
  };

  programs = {
    claude-code = {
      enable   = true;
      package  = inputs.llm-agents.packages.aarch64-darwin.claude-code;
      settings = {
        permissions = {
          allow       =
            [ "Bash" "Read(~/Workspace/**)" "WebFetch" "WebSearch" ];
          defaultMode = "acceptEdits";
        };
        sandbox     = {
          autoAllowBashIfSandboxed = true;
          enabled                  = true;
        };
      };
    };

    home-manager = { enable = true; };

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
