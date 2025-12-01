{ config, lib, pkgs, ... }: {
  home = {
    sessionPath      = [
      "${config.xdg.dataHome}/bin"
      "${config.home.homeDirectory}/.orbstack/bin"
      "/opt/homebrew/bin" "/opt/homebrew/sbin"
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
    (import ../home-manager/amp {
      inherit pkgs;
      mcpSettings = {
        buildkite         = {
          args    = [ "mcp-remote" "https://mcp.buildkite.com/mcp/readonly" ];
          command = "npx";
        };
        github-mcp-server = {
          args    = [ "stdio" "--read-only" ];
          command = "${pkgs.github-mcp-server}/bin/github-mcp-server";
        };
      };
    })
  ];

  programs = {
    fish         = {
      interactiveShellInit =
        "source ${config.xdg.configHome}/fish/config.local.fish";
    };
    git          = {
      ignores  = [ ".aiignore" ".junie" "index.scip" ];
      settings = {
        user.email = lib.mkForce("michal.kielbowicz@sourcegraph.com");
      };
    };
  };

  xdg.configFile."ideavim/ideavimrc".source = ./config/ideavimrc;
}
