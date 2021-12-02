{
  compression         = true;
  controlMaster       = "auto";
  controlPersist      = "yes";
  enable              = true;
  forwardAgent        = true;
  matchBlocks         =
    let config = {
      hostname       = "jupblb.ddns.net";
      identitiesOnly = true;
      identityFile   = [ (toString ./id_ed25519) ];
    };
    in {
      dionysus     = config // { port = 1995; };
      "github.com" = config // { hostname = "github.com"; };
      hades        = config // { port = 1993; };
    };
  serverAliveInterval = 30;
}
