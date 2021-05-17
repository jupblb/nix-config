{ delta, fetchurl }:

let config-override-patch = fetchurl {
  url    = https://github.com/dandavison/delta/pull/573.diff;
  sha256 = "1imncvfcb55jglcqcy04b6n62nlrrxclsn5xv9shrfml0dp3cdqg";
};
in delta.overrideAttrs(_: { patches = [ config-override-patch ]; })
