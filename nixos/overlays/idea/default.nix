{ buildPackages, jetbrains, linuxPackages_latest, makeWrapper, symlinkJoin }:

let
  idea-ultimate' = jetbrains.idea-ultimate.overrideAttrs (old: rec {
    name    = "idea-ultimate-${version}";
    version = "2019.3.4";
    src     = buildPackages.fetchurl {
      url    = "https://download.jetbrains.com/idea/ideaIU-${version}.tar.gz";
      sha256 = "0ymwanzyh09v2igxzhx8gws711a5b987vhdjbb7flav3b5qf8l3g";
    };
  });
in
  symlinkJoin {
    buildInputs = [ makeWrapper ];
    name        = "idea";
    paths       = [ idea-ultimate' ];
    postBuild   = ''
      wrapProgram "$out/bin/idea-ultimate" \
      --prefix PATH : ${linuxPackages_latest.perf}/bin \
      --set-default IDEA_JDK "${jetbrains.jdk}" \
      --set-default IDEA_PROPERTIES "${./idea.properties}" \
      --set-default IDEA_VM_OPTIONS "${./idea64.vmoptions}"
    '';
  }
