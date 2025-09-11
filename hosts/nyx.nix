{ config, lib, nix-ai-tools, pkgs, ... }: {
  fonts.fontconfig = { enable = true; };

  home = {
    homeDirectory    = "/Users/jupblb";
    packages         =
      let
        iosevka  = pkgs.iosevka-bin.override { variant = "SGr-Iosevka"; };
        ai-tools = with nix-ai-tools.packages.aarch64-darwin;
          [ amp gemini-cli ];
      in ai-tools ++ (with pkgs; [ glow iosevka ]);
    sessionPath      = [
      "${config.xdg.dataHome}/bin" "/opt/homebrew/bin"
      "/opt/homebrew/sbin" "/opt/podman/bin"
    ];
    sessionVariables = {
      CARGOHOME           = "${config.xdg.dataHome}/cargo";
      GOPATH              = "${config.xdg.dataHome}/go";
      HOMEBREW_PREFIX     = "/opt/homebre";
      HOMEBREW_CELLAR     = "/opt/homebrew/Cellar";
      HOMEBREW_REPOSITORY = "/opt/homebrew";
    };
    shellAliases     = { "blaze" = "bazel"; };
    stateVersion     = "25.05";
    username         = "jupblb";
  };

  imports = [
    ../home-manager
    ../home-manager/direnv.nix
    ../home-manager/firefox
    ../home-manager/fish
    ../home-manager/kitty.nix
    ../home-manager/lf
    ../home-manager/neovim
  ];

  programs = {
    firefox      = {
      policies         = {
        ExtensionSettings = {
          "plugin@okta.com" = {
            install_url       =
              "https://addons.mozilla.org/en-US/firefox/downloads" +
                "/latest/okta-browser-plugin/latest.xpi";
            installation_mode = "normal_installed";
          };
          "{bf855ead-d7c3-4c7b-9f88-9a7e75c0efdf}" = {
            install_url       =
              "https://addons.mozilla.org/en-US/firefox/downloads" +
                "/latest/zoom_new_scheduler/latest.xpi";
            installation_mode = "normal_installed";
          };
        };
      };
      profiles.default = {
        bookmarks = {
          settings = [
            {
              name    = "Cloud Ops";
              keyword = "ops";
              url     = "https://cloud-ops.sgdev.org";
            }
            {
              name    = "Notion";
              keyword = "notion";
              url     = "https://www.notion.so/sourcegraph";
            }
            {
              name    = "Okta";
              keyword = "okta";
              url     = "https://sourcegraph.okta.com";
            }
            {
              name    = "Sourcegraph";
              keyword = "dotcom";
              url     = "https://sourcegraph.com/search";
            }
            {
              name    = "Sourcegraph2";
              keyword = "s2";
              url     = "https://sourcegraph.sourcegraph.com/search";
            }
            {
              name    = "Sourcegraph Test";
              keyword = "test";
              url     = "https://sourcegraph.test:3443/search";
            }
          ];
        };
      };
    };
    fish         = {
      interactiveShellInit =
        "source ${config.xdg.configHome}/fish/config.local.fish";
    };
    git          = {
      # Not supported by Apple default git binary
      extraConfig = { core.fsmonitor = lib.mkForce false; };
      ignores     = [ "index.scip" ];
      userEmail   = lib.mkForce("michal.kielbowicz@sourcegraph.com");
    };
    home-manager = { enable = true; };
    kitty        = {
      font        = { size = lib.mkForce 14; };
      keybindings = { "cmd+t" = "new_tab_with_cwd"; };
      settings    = {
        hide_window_decorations            = lib.mkForce "no";
        macos_option_as_alt                = "left";
        macos_quit_when_last_window_closed = "yes";
      };
    };
    mise         = { enable = true; };
  };

  services = { syncthing.enable = true; };

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
