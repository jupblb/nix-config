{ pkgs, ... }: {
  home.packages =
    let
      # Re-sign with a stable identifier so macOS Keychain recognizes the
      # binary across Nix upgrades (the upstream package uses linker-signed
      # which changes identity on every rebuild).
      amp-cli = pkgs.amp-cli.overrideAttrs (old: {
        postFixup = builtins.replaceStrings
          [ "--code-signature-flags linker-signed" ]
          [ "--binary-identifier com.sourcegraph.amp" ]
          old.postFixup;
      });
      amp = pkgs.symlinkJoin({
        name        = "amp";
        paths       = [ amp-cli ];
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
      "amp.agent.deepReasoningEffort"                     = "xhigh";
      "amp.dangerouslyAllowAll"                           = true;
      "amp.experimental.cli.nativeSecretsStorage.enabled" =
        pkgs.stdenv.isDarwin;
      "amp.git.commit.coauthor.enabled"                   = false;
      "amp.git.commit.ampThread.enabled"                  = false;
      "amp.tools.inactivityTimeout"                       = 6000;
      "amp.tools.stopTimeout"                             = 6000;
    });
  };
}
