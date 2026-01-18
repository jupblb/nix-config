{ inputs, lib, pkgs, ... }: {
  determinate-nix.customSettings = {
    trusted-users = [ "@admin" ];
  };

  environment = {
    systemPackages = with pkgs; [ bashInteractive git ];
  };

  fonts.packages = [ (pkgs.iosevka-bin.override { variant = "SGr-Iosevka"; }) ];

  home-manager = {
    backupFileExtension = "bak";

    sharedModules = [ {
      home = { stateVersion = "25.05"; };

      # https://github.com/nix-community/home-manager/issues/7935
      manual = { manpages.enable = false; };

      imports = [
        ../home-manager
        ../home-manager/fish
        ../home-manager/kitty.nix
        ../home-manager/lf
        ../home-manager/neovim
      ];

      nixpkgs = {
        config   = { allowUnfree = true; };
        overlays = with inputs.llm-agents.packages.aarch64-darwin;
          [ (_: _: { amp-cli = amp; }) ];
      };

      programs = {
        git = {
          settings = {
            # Not supported by Apple default git binary
            core.fsmonitor = lib.mkForce false;
            safe.directory = "/private/etc/nix-darwin";
          };
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

      targets.darwin = {
        defaults = {
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
        linkApps = { enable = false; };
      };
    } ];

    users = {
      michal = { config, ... }: {
        home = {
          sessionPath      = [
            "${config.home.homeDirectory}/.orbstack/bin"
            "/opt/homebrew/bin" "/opt/homebrew/sbin"
          ];
          sessionVariables = {
            HOMEBREW_PREFIX     = "/opt/homebrew";
            HOMEBREW_CELLAR     = "/opt/homebrew/Cellar";
            HOMEBREW_REPOSITORY = "/opt/homebrew";
          };
        };

        programs = {
          claude-code  = {
            enable   = true;
            package  = inputs.llm-agents.packages.aarch64-darwin.claude-code;
            settings = {
              permissions = {
                deny        = [ "Read(~/**)" ];
                allow       = [ "Read(~/Workspace/**)" "Bash(*)" ];
                defaultMode = "acceptEdits";
              };
              sandbox = {
                enabled                  = true;
                autoAllowBashIfSandboxed = true;
              };
            };
          };
          git          = {
            ignores  = [ ".aiignore" ".junie" "index.scip" ];
            settings = {
              user.email = lib.mkForce("michal.kielbowicz@sourcegraph.com");
            };
          };
        };

        xdg.configFile."ideavim/ideavimrc".source = ./config/ideavimrc;
      };

      jupblb = {};
    };
  };

  imports = [
    inputs.determinate.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
  ];

  # https://docs.determinate.systems/guides/nix-darwin
  nix = { enable = false; };

  nixpkgs = { hostPlatform = "aarch64-darwin"; };

  programs = {
    fish = { enable = true; };
  };

  security = {
    pam.services.sudo_local = {
      touchIdAuth = true;
      watchIdAuth = true;
    };
  };

  system = {
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    keyboard              = {
      enableKeyMapping      = true;
      remapCapsLockToEscape = true;
    };
    startup               = { chime = false; };
    stateVersion          = 6;
  };

  users.users = {
    jupblb = { home = "/Users/jupblb"; };
    michal = { home = "/Users/michal"; };
  };
}
