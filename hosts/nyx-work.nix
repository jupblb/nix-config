{ config, lib, pkgs, ... }: {
  home = {
    sessionPath      = [
      "${config.xdg.dataHome}/bin" "/opt/homebrew/bin"
      "/opt/homebrew/sbin" "/opt/podman/bin"
    ];
    sessionVariables = {
      HOMEBREW_PREFIX     = "/opt/homebre";
      HOMEBREW_CELLAR     = "/opt/homebrew/Cellar";
      HOMEBREW_REPOSITORY = "/opt/homebrew";
    };
    shellAliases     = { "blaze" = "bazel"; };
    stateVersion     = "25.05";
    username         = lib.mkForce("michal");
  };

  imports = [
    ../home-manager
    (import ../home-manager/amp {
      inherit pkgs;
      mcpSettings = {
        buildkite         = {
          args    = [ "mcp-remote" "https://mcp.buildkite.com/mcp/readonly" ];
          command = "${pkgs.nodejs}/bin/npx";
        };
        chrome-devtools   = {
          args    = [ "chrome-devtools-mcp@latest" ];
          command = "${pkgs.nodejs}/bin/npx";
        };
        context7          = { url = "https://mcp.context7.com/mcp"; };
        github-mcp-server = {
          args    = [ "stdio" "--read-only" ];
          command = "${pkgs.github-mcp-server}/bin/github-mcp-server";
        };
        linear            = {
          args    = [ "mcp-remote" "https://mcp.linear.app/sse" ];
          command = "${pkgs.nodejs}/bin/npx";
        };
        sourcegraph       = {
          url     = "\${SRC_ENDPOINT}/.api/mcp/v1";
          headers = {
            "Authorization" = "token \${SRC_ACCESS_TOKEN}";
          };
        };
      };
    })
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
      ignores     = [ ".aiignore" ".junie" "index.scip" ];
      userEmail   = lib.mkForce("michal.kielbowicz@sourcegraph.com");
    };
    mise         = { enable = true; };
  };

  xdg.configFile."ideavim/ideavimrc".source = ./config/ideavimrc;
}
