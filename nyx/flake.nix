# Additional config:
# - https://apple.stackexchange.com/a/214349
{
  inputs = {
    home-manager = {
      url    = "github:nix-community/home-manager/release-25.05";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
    # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1466965161
    mac-app-util = {
      url    = "github:hraban/mac-app-util";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
    nix-ai-tools = {
      # inputs = { nixpkgs.follows = "nixpkgs"; };
      url    = "github:numtide/nix-ai-tools";
    };
    nixpkgs      = { url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin"; };
  };

  outputs = { home-manager, mac-app-util, nix-ai-tools, nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      pkgs   = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations."jupblb" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          mac-app-util.homeManagerModules.default

          ../home-manager
          ../home-manager/direnv.nix
          ../home-manager/firefox
          ../home-manager/fish
          ../home-manager/kitty.nix
          ../home-manager/lf
          ../home-manager/neovim

          ({ config, lib, ... }: {
            fonts.fontconfig = { enable = true; };

            home = {
              homeDirectory    = "/Users/jupblb";
              packages         =
                let
                  iosevka  =
                    pkgs.iosevka-bin.override { variant = "SGr-Iosevka"; };
                  ai-tools = with nix-ai-tools.packages.${system};
                    [ amp crush gemini-cli ];
                in ai-tools ++ (with pkgs; [ google-cloud-sdk iosevka vhs ]);
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
                  };
                };
                profiles.default = {
                  bookmarks = {
                    settings = [
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
                        url     = "https://sourcegraph.sourcegraph.com/";
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

            services = { syncthing.enable = true; };
          })
        ];
      };
    };
}
