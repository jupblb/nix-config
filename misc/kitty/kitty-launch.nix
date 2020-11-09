{ fortune, writeTextFile }:

writeTextFile {
  name = "kitty-launch";
  text = "launch fish -C '${fortune}/bin/fortune -sa'";
}

