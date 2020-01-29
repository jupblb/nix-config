{ jetbrains, symlinkJoin, makeWrapper }:

symlinkJoin {
  name = "idea";
  buildInputs = [ makeWrapper ];
  paths = [ jetbrains.idea-ultimate ]; #.override { jdk = jetbrains.jdk; } ];
  postBuild = ''
    wrapProgram "$out/bin/idea-ultimate" \
    --set-default IDEA_VM_OPTIONS "${./idea64.vmoptions}" \
    --set-default IDEA_JDK "${jetbrains.jdk}"
  '';
}
