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
    (import ../home-manager/amp {
      inherit pkgs;
      mcpSettings = {
        buildkite         = {
          args    = [ "mcp-remote" "https://mcp.buildkite.com/mcp/readonly" ];
          command = "${pkgs.nodejs}/bin/npx";
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
      ignores     = [ ".aiignore" ".junie" "index.scip" ];
      userEmail   = lib.mkForce("michal.kielbowicz@sourcegraph.com");
    };
    mise         = { enable = true; };
  };

  xdg.configFile."ideavim/ideavimrc".source = ./config/ideavimrc;
}
