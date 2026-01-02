{ config, lib, ... }: {
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

  programs = {
    claude-code  = {
      enable   = true;
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
