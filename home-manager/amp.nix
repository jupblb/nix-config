{ pkgs, ... }: {
  home.packages =
    let
      amp = pkgs.symlinkJoin({
        name        = "amp";
        paths       = [ pkgs.amp-cli ];
        buildInputs = with pkgs; [ makeWrapper ];
        postBuild   =
          let path = with pkgs; [ gnused ];
          in ''
            wrapProgram $out/bin/amp \
              --prefix PATH : ${pkgs.lib.makeBinPath(path)} \
              --set GIT_EDITOR true
          '';
      });
    in [ amp ];

  xdg.configFile = {
    "amp/plugins/amp-neovim-diagnostics.ts".source =
      "${pkgs.vimPlugins.amp-nvim.src}/plugin/amp-neovim-diagnostics.ts";

    "amp/settings.json".text = builtins.toJSON({
      "amp.agent.deepReasoningEffort"    = "xhigh";
      "amp.dangerouslyAllowAll"          = true;
      "amp.defaultVisibility"            = "private";
      "amp.git.commit.coauthor.enabled"  = false;
      "amp.git.commit.ampThread.enabled" = false;
      "amp.tools.inactivityTimeout"      = 600;
      "amp.tools.stopTimeout"            = 600;
    });
  };
}
