{ pkgs, ... }: {
  home = {
    packages =
      let
        # https://github.com/NixOS/nixpkgs/pull/422339
        amp-cli    = pkgs.writeShellApplication({
          name          = "amp";
          runtimeInputs = with pkgs; [ nodejs ];
          text          = ''exec npx --yes @sourcegraph/amp "$@"'';
        });
        gemini-cli = pkgs.writeShellApplication({
          name          = "gemini-cli";
          runtimeInputs = with pkgs; [ nodejs ];
          text          = ''exec npx --yes @google/gemini-cli "$@"'';
        });
      in [ amp-cli gemini-cli ];
  };
}
