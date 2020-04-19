{ bat, makeWrapper, symlinkJoin }:

symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "bat";
  paths       = [ bat ];
  postBuild   = ''
    wrapProgram "$out/bin/bat" \
      --set-default BAT_CONFIG_PATH "${builtins.toString ./.}" \
      --set-default BAT_CACHE_PATH "${builtins.toString ./.}" \
      --set-default BAT_THEME gruvbox
  '';
}
