self: super: with super; {
  emanote      =
    let url = "https://github.com/srid/emanote/archive/master.tar.gz";
    in import (builtins.fetchTarball url);
  pragmata-pro = callPackage ./pragmata-pro {};
}
