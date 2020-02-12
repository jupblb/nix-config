{ buildPackages, jetbrains, linuxPackages_latest, makeWrapper, symlinkJoin }:

let
  idea-ultimate' = jetbrains.idea-ultimate.overrideAttrs (old: rec {
    name    = "idea-ultimate-${version}";
    version = "2019.3.3";
    src     = buildPackages.fetchurl {
      url    = "https://download.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "1mmhqh243yjf348zcwn53ggv4n1b6xv7c2hppvcbwa756rzkc6x7";
    };
  });
in
  symlinkJoin {
    buildInputs = [ makeWrapper ];
    name        = "idea";
    paths       = [ idea-ultimate' linuxPackages_latest.perf ];
    postBuild   = ''
      wrapProgram "$out/bin/idea-ultimate" \
      --set-default IDEA_JDK "${jetbrains.jdk}" \
      --set-default IDEA_PROPERTIES "${./idea.properties}" \
      --set-default IDEA_VM_OPTIONS "${./idea64.vmoptions}"
    '';
  }
