{
  compression         = true;
  controlMaster       = "auto";
  controlPersist      = "yes";
  enable              = true;
  forwardAgent        = true;
  matchBlocks         = let config = { identitiesOnly = true; }; in {
    dionysus     = config // {
      hostname     = "jupblb.ddns.net";
      identityFile = [ (toString ./jupblb/id_ed25519) ];
      port         = 1995;
      sendEnv      = [ "BAT_THEME" ];
    };
    "github.com" = config // {
      hostname     = "github.com";
      identityFile = [ (toString ./git/id_ed25519) ];
    };
    hades        = config // {
      hostname     = "jupblb.ddns.net";
      identityFile = [ (toString ./jupblb/id_ed25519) ];
      port         = 1993;
      sendEnv      = [ "BAT_THEME" ];
    };
    poseidon     = config // {
      hostname     = "poseidon.kielbowi.cz";
      identityFile = [ (toString ./jupblb/id_ed25519) ];
      sendEnv      = [ "BAT_THEME" ];
    };
  };
  serverAliveInterval = 30;
}