{ jetbrains, symlinkJoin, makeWrapper }:

symlinkJoin {
  name = "idea";
  buildInputs = [ makeWrapper ];
  paths = [ jetbrains.idea-ultimate ];
  postBuild = ''
    wrapProgram "$out/bin/idea-ultimate" \
    --set-default IDEA_JDK "${jetbrains.jdk}" \
    --set-default IDEA_PROPERTIES "${./idea.properties}" \
    --set-default IDEA_VM_OPTIONS "${./idea64.vmoptions}"
  '';
}
