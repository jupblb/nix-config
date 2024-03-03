{ config, pkgs, ... }: {
  home.packages = with pkgs; [ git-crypt ];

  programs = {
    git = { signing = { key = "1F516D495D5D8D5B"; signByDefault = true; }; };
    gpg = {
      enable  = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };
    ssh = {
      controlMaster  = "auto";
      controlPersist = "yes";
      enable         = true;
      matchBlocks    =
        let common = {
          identitiesOnly = true;
          identityFile   = [ (toString ../config/ssh/id_ed25519) ];
          user           = "jupblb";
        };
        in {
          dionysus     = common // {
            hostname     = "dionysus.kielbowi.cz";
            proxyCommand =
              "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
          };
          "prose.sh"   = common // { hostname = "prose.sh"; };
        };
    };
  };
}
