{ config, lib, pkgs, ... }: {
  home.activation.copyApplications =
    let apps = pkgs.buildEnv {
      name = "home-manager-applications";
      paths = config.home.packages;
      pathsToLink = "/Applications";
    };
    in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      baseDir="${config.home.homeDirectory}/Applications/Home Manager"
      if [ -d "$baseDir" ]; then
        $DRY_RUN_CMD rm -rf "$baseDir"
      fi
      mkdir -p "$baseDir"
      for appFile in ${apps}/Applications/*; do
        target="$baseDir/$(basename "$appFile")"
        $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
        $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
      done
    '';

  programs.kitty = { font.size = lib.mkForce 14; };
}
