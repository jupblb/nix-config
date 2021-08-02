{ system, tabnine }:

let tabnine-version = builtins.readFile(builtins.fetchurl {
  url = https://update.tabnine.com/bundles/version;
});
in tabnine.overrideAttrs(_: {
  version = tabnine-version;
  src     = builtins.fetchurl {
    url = let prefix = "https://update.tabnine.com/bundles"; in
      if system == "x86_64-darwin" then
        "${prefix}/${tabnine-version}/x86_64-apple-darwin/TabNine.zip"
      else if system == "x86_64-linux" then
        "${prefix}/${tabnine-version}/x86_64-unknown-linux-musl/TabNine.zip"
      else throw "Not supported on ${system}";
  };
})
