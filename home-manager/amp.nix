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
              --prefix PATH : ${pkgs.lib.makeBinPath(path)}
          '';
      });
    in [ amp ];

  xdg.configFile = {
    "amp/settings.json".text = builtins.toJSON({
      "amp.dangerouslyAllowAll"            = true;
      "amp.defaultVisibility"              = "private";
      "amp.git.commit.ampThread.enabled"   = false;
      "amp.git.commit.coauthor.enabled"    = false;
      "amp.skills.disableClaudeCodeSkills" = true;
      "amp.updates.mode"                   = "disabled";
    });
  };
}
