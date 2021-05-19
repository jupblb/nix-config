{ copyPathToStore, runCommandNoCC, unzip }:

let version = "0.829";
in runCommandNoCC "pragmata-pro-${version}" {
  buildInputs = [ unzip ];
  src         = copyPathToStore "${toString ./.}/PragmataPro${version}.zip";
} ''
  mkdir -p $out/share/fonts
  unzip -jo $src \*.ttf -d $out/share/fonts/truetype
''
