{ lib, ... }: {
  services.syncthing = {
    enable           = true;
    group            = "users";
    openDefaultPorts = true;
    settings         = {
      devices = {
        artemis   = {
          autoAcceptFolders = true;
          id                =
            "6SIVI3F-YGGPC5T-KFUH3QG-RVCA5U5-SJ2QFGC-STA6KJ3-ITWXE53-3OA6UQW";
        };
        dionysus  = {
          autoAcceptFolders = true;
          id                =
            "AUAEQVM-GLWFEY7-ISXW5C6-5FSTG6O-J4D7FI2-LZC7NVM-7AQP4GT-TUBMYA6";
        };
        hades     = {
          autoAcceptFolders = true;
          id                =
            "XTWE5SD-D7HSMCA-5XSO5HO-B2WHNXM-TNPCG2O-FCHX3GJ-65P6ZGY-SYCPHQQ";
        };
      };
      folders = {
        "jupblb/Documents" = {
          devices = [ "artemis" "dionysus" "hades" ];
          enable  = lib.mkDefault false;
        };
        "jupblb/Pictures"  = {
          devices = [ "artemis" "dionysus" "hades" ];
          enable  = lib.mkDefault false;
        };
        "jupblb/Workspace" = {
          devices     = [ "artemis" "dionysus" "hades" ];
          enable      = lib.mkDefault false;
          ignorePerms = false;
        };
      };
      options = {
        urAccepted           = 1;
        localAnnounceEnabled = true;
      };
    };
  };
}
