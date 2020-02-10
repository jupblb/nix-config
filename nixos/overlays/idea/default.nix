{ jetbrains, linuxPackages_latest, makeWrapper, symlinkJoin }:

symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "idea";
  paths       = [ jetbrains.idea-ultimate linuxPackages_latest.perf ];
  postBuild   = ''
    wrapProgram "$out/bin/idea-ultimate" \
    --set-default IDEA_JDK "${jetbrains.jdk}" \
    --set-default IDEA_PROPERTIES "${./idea.properties}" \
    --set-default IDEA_VM_OPTIONS "${./idea64.vmoptions}"
  '';
}
