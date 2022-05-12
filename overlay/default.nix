self: super: with super; {
  emanote      =
    let url = "https://github.com/srid/emanote/archive/master.tar.gz";
    in (import (builtins.fetchTarball url)).default;
  pragmata-pro = callPackage ./pragmata-pro {};
}
