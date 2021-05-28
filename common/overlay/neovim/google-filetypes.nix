{ copyPathToStore, symlinkJoin }: { pluginPath }:

let plugin = copyPathToStore pluginPath; in symlinkJoin {
  name      = "google-filetypes";
  paths     = [ pluginPath ];
  postBuild = ''
    # Remove files that use maktaba
    rm -rf $out/{autoload,instant,plugin,vroom} \
      $out/ftplugin/{borg,gcl,millwheel,piperspec}.vim
  '';
}
