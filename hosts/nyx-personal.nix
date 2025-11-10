{ pkgs, ... }: {
  imports  = [ (import ../home-manager/amp { inherit pkgs; }) ];
  services = { syncthing.enable = true; };
}
