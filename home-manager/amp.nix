{ pkgs, ... }: {
  home.packages =
    let amp = pkgs.symlinkJoin({
      name        = "amp";
      paths       = [ pkgs.amp-cli ];
      buildInputs = with pkgs; [ makeWrapper ];
      postBuild   =
        let path = with pkgs; [ gnused nodejs ];
        in ''
          wrapProgram $out/bin/amp \
            --prefix PATH : ${pkgs.lib.makeBinPath(path)} \
            --set GIT_EDITOR=true
        '';
    });
    in [ amp ];

  xdg.configFile = {
    "amp/settings.json".text = builtins.toJSON({
      "amp.dangerouslyAllowAll"                           = true;
      "amp.experimental.cli.nativeSecretsStorage.enabled" = true;
      "amp.git.commit.coauthor.enabled"                   = false;
      "amp.git.commit.ampThread.enabled"                  = false;
      "amp.tools.inactivityTimeout"                       = 600;
      "amp.tools.stopTimeout"                             = 600;
    });
  };
}
