{ fetchurl, glow-nvim }:

let esc-patch = fetchurl {
  url    =
    "https://github.com/npxbr/glow.nvim/commit/c9d156d03a4edb5a91d5862cb3e218392450ef74.diff";
  sha256 = "1xvdmcsyxn1chz9wkijvml9q535a8ldfz8a8064r65rwmxi023g4";
};
in glow-nvim.overrideAttrs(_: { patches = [ esc-patch ]; })
