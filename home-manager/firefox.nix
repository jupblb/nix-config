{ pkgs, ... }: {
  fonts.fontconfig = { enable = true; };

  home.packages = with pkgs; [
    (iosevka-bin.override({ variant = "SGr-Iosevka"; }))
  ];

  programs.firefox = {
    enable               = true;
    languagePacks        = [ "pl" "en-US" ];
    nativeMessagingHosts = with pkgs; [ tridactyl-native ];
    profiles.default     = {
      search      = {
        engines = {
          google = { metaData.alias = "@g"; };
          kagi   = {
            definedAliases  = [ "@k" ];
            iconMapObj."16" = "https://kagi.com/favicon.ico";
            urls        = [
              { template = "https://kagi.com/search?q={searchTerms}"; }
            ];
            suggestions = [
              {
                template = "https://kagi.com/api/autosuggest?q={searchTerms}";
              }
            ];
          };
          maps   = {
            definedAliases  = [ "@m" ];
            iconMapObj."16" = "https://www.google.com/favicon.ico";
            urls            = [
              { template = "https://www.google.com/maps/search/{searchTerms}"; }
            ];
          };
          nix    = {
            definedAliases  = [ "@nix" ];
            iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
            urls            = [
              {
                template =
                  "https://wiki.nixos.org/w/index.php?search={searchTerms}";
              }
            ];
          };
          nixos  = {
            definedAliases  = [ "@nixos" ];
            iconMapObj."16" = "https://nixos.org/favicon.ico";
            name            = "NixOS Options";
            urls            = [
              {
                template =
                  "https://search.nixos.org/options?query={searchTerms}";
              }
            ];
          };
        };
        force   = true;
        order   = [ "kagi" "google" ];
      };
      settings    = {
        "full-screen-api.warning.timeout"                     = 0;
        "general.warnOnAboutConfig"                           = false;
        "permissions.default.desktop-notification"            = 2;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userContent = ''
        @-moz-document domain(github.com) {
          .blob-code, .blob-code-inner, .pl-mi {
            font-family: "Iosevka" !important;
            font-weight: normal !important;
            font-style: normal !important;
          }
        }

        code {
          font-family: "Iosevka" !important;
          font-weight: normal !important;
          font-style: normal !important;
        }
      '';
    };
  };
}
