# Additional config:
# - https://apple.stackexchange.com/a/214349
{
  inputs = {
    home-manager = {
      url    = "github:nix-community/home-manager/release-25.05";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
    # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1466965161
    mac-app-util = { url = "github:hraban/mac-app-util"; };
    nixpkgs      = { url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin"; };
  };

  outputs = { home-manager, mac-app-util, nixpkgs, ... }:
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
          ../home-manager/ai.nix
          ../home-manager/direnv.nix
          ../home-manager/fish
          ../home-manager/kitty.nix
          ../home-manager/neovim

          ({ config, lib, ... }: {
            fonts.fontconfig = { enable = true; };

            home = {
              homeDirectory    = "/Users/jupblb";
              packages         = with pkgs; [
                (iosevka-bin.override { variant = "SGr-Iosevka"; })
                jetbrains.goland
              ];
              sessionPath      = [ "${config.home.homeDirectory}/.sg" ];
              sessionVariables = {
                CARGOHOME = "${config.xdg.dataHome}/cargo";
                GOPATH    = "${config.xdg.dataHome}/go";
              };
              stateVersion     = "25.05";
              username         = "jupblb";
            };

            programs = {
              git          = {
                # Not supported by Apple default git binary
                extraConfig = { core.fsmonitor = lib.mkForce false; };
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
