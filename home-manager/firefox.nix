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
          google     = { metaData.alias = "@g"; };
          kagi       = {
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
          nixos-wiki = {
            definedAliases  = [ "@nw" ];
            iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
            name            = "NixOS Wiki";
            urls            = [
              {
                template =
                  "https://wiki.nixos.org/w/index.php?search={searchTerms}";
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
