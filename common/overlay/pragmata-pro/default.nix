{ copyPathToStore, fetchurl, runCommandNoCC, unzip }:

let
  version = "0.829";
  glyphs  = fetchurl {
    name   = "nerd-font-symbols";
    sha256 = "10kqjkr4644s7c3b00b3q548ia4x327zxsszdqbgqn62szdfb30i";
    url    =
      "https://github.com/ryanoasis/nerd-fonts/raw/master/src/glyphs/Symbols-1000-em%20Nerd%20Font%20Complete.ttf";
  };
in runCommandNoCC "pragmata-pro-${version}" {
  buildInputs = [ unzip ];
  src         = copyPathToStore "${toString ./.}/PragmataPro${version}.zip";
} ''
  mkdir -p $out/share/fonts
  unzip -jo $src \*.ttf -d $out/share/fonts/truetype
  cp ${glyphs} $out/share/fonts/truetype
''
