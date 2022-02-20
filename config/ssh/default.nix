{
  compression         = true;
  controlMaster       = "auto";
  controlPersist      = "yes";
  enable              = true;
  forwardAgent        = true;
  matchBlocks         =
    let config = {
      identitiesOnly = true;
      identityFile   = [ (toString ./id_ed25519) ];
      sendEnv        = [ "BAT_THEME" ];
    };
    in {
      dionysus     = config // {
        hostname = "jupblb.ddns.net";
        port     = 1995;
      };
      "github.com" = config // { hostname = "github.com"; };
      hades        = config // {
        hostname = "jupblb.ddns.net";
        port     = 1993;
      };
    };
  serverAliveInterval = 30;
}
