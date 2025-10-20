{ pkgs, mcpSettings ? {}, ... }: {
  home.packages =
    let amp = pkgs.symlinkJoin({
      name        = "amp";
      paths       = [ pkgs.amp-cli ];
      buildInputs = with pkgs; [ makeWrapper ];
      postBuild   =
        let path = with pkgs; [ gnused nodejs ];
        in ''
          wrapProgram $out/bin/amp \
            --prefix PATH : ${pkgs.lib.makeBinPath(path)}
        '';
    });
    in [ amp ];


  xdg.configFile."amp/settings.json" =
    let formatter = pkgs.formats.json {};
    in {
      source = formatter.generate "amp-settings.json" ({
        "amp.dangerouslyAllowAll"          = true;
        "amp.experimental.agentMode"       = "opus4.1";
        "amp.experimental.librarian"       = true;
        "amp.git.commit.coauthor.enabled"  = false;
        "amp.git.commit.ampThread.enabled" = true;
        "amp.internal.oracleModel"         = "gpt-5-codex";
        "amp.mcpServers"                   = mcpSettings;
        "amp.tools.inactivityTimeout"      = 600;
        "amp.tools.stopTimeout"            = 600;
      });
    };
}
