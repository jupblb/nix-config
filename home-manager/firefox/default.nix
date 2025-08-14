{ pkgs, ... }: {
  fonts.fontconfig = { enable = true; };

  home.packages = with pkgs; [
    (iosevka-bin.override({ variant = "SGr-Iosevka"; }))
  ];

  programs.firefox = {
    enable               = true;
    languagePacks        = [ "pl" "en-US" ];
    nativeMessagingHosts = with pkgs; [ tridactyl-native ];
    policies             = {
      DisableFirefoxScreenshots = true;
      ExtensionSettings         =
        # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265/17
        # nix run github:tupakkatapa/mozid -- <url>
        let ext = shortId: uuid: {
          name  = uuid;
          value = {
            install_url       =
              "https://addons.mozilla.org/en-US/firefox/downloads/latest" +
                "/${shortId}/latest.xpi";
            installation_mode = "normal_installed";
          };
        };
        in builtins.listToAttrs([
          (ext "clearurls"       "{74145f27-f039-47ce-a470-a662b129930a}")
          (ext "consent-o-matic" "gdpr@cavi.au.dk")
          (ext "sponsorblock"    "sponsorBlocker@ajay.app")
          (ext "tree-style-tab"  "treestyletab@piro.sakura.ne.jp")
          (ext "tridactyl-vim"   "tridactyl.vim@cmcaine.co.uk")
          (ext "ublock-origin"   "uBlock0@raymondhill.net")
        ]);
    };
    profiles.default     = {
      bookmarks   = {
        force    = true;
        settings = [
          {
            name    = "home-manager options";
            keyword = "hm";
            url     =
              "https://nix-community.github.io/home-manager/options.xhtml";
          }
          {
            name    = "nixpkgs";
            keyword = "nixpkgs";
            url     = "https://github.com/NixOS/nixpkgs";
          }
        ];
      };
      search      = {
        default = "kagi";
        engines = {
          bing   = { metaData.hidden = true; };
          ddg    = { metaData.hidden = true; };
          ebay   = { metaData.hidden = true; };
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
            definedAliases  = [ "@nixpr" ];
            iconMapObj."16" = "https://nixos.org/favicon.ico";
            urls            = [
              {
                template = "https://nixpk.gs/pr-tracker.html?pr={searchTerms}";
              }
            ];
          };
          nixpr  = {
            definedAliases  = [ "@nixos" ];
            iconMapObj."16" = "https://nixos.org/favicon.ico";
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
        "full-screen-api.warning.timeout"          = 0;
        "browser.aboutConfig.showWarning"          = false;
        "browser.ml.chat.provider"                 =
          "https://gemini.google.com";
        "general.warnOnAboutConfig"                = false;
        # Disable desktop notifications for websites
        "permissions.default.desktop-notification" = 2;
        # Disable containers
        "privacy.userContext.enabled"              = false;
      };
      userContent = builtins.readFile(./userContent.css);
    };
  };
}
