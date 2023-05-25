{ lib, ... }: {
  services.syncthing = {
    devices          = {
      artemis = {
        autoAcceptFolders = true;
        id                =
          "IZVLNXF-53N6C2N-JZJ3AOH-EUOQOFY-JM4CTK7-36EQ4LI-TQC576X-PTTKZAH";
      };
      dionysus = {
        autoAcceptFolders = true;
        id                =
          "AUAEQVM-GLWFEY7-ISXW5C6-5FSTG6O-J4D7FI2-LZC7NVM-7AQP4GT-TUBMYA6";
      };
      domci-mac = {
        autoAcceptFolders = true;
        id                =
          "RJGQXK6-PVF3555-5U3Y6MK-ADF2SH3-I7VF5UK-U56PSCR-PZJEAF5-5QFZHQ2";
      };
      hades = {
        autoAcceptFolders = true;
        id                =
          "XTWE5SD-D7HSMCA-5XSO5HO-B2WHNXM-TNPCG2O-FCHX3GJ-65P6ZGY-SYCPHQQ";
      };
    };
    enable           = true;
    folders          = {
      "domci/Documents"  = {
        devices = [ "dionysus" "domci-mac" ];
        enable  = lib.mkDefault false;
      };
      "domci/Pictures"   = {
        devices = [ "dionysus" "domci-mac" ];
        enable  = lib.mkDefault false;
      };
      "domci/Videos"     = {
        devices = [ "dionysus" "domci-mac" ];
        enable  = lib.mkDefault false;
      };
      "jupblb/Documents" = {
        devices = [ "artemis" "dionysus" "hades" ];
        enable  = lib.mkDefault false;
      };
      "jupblb/Pictures"  = {
        devices = [ "artemis" "dionysus" "hades" ];
        enable  = lib.mkDefault false;
      };
      "jupblb/Workspace" = {
        devices = [ "artemis" "dionysus" "hades" ];
        enable  = lib.mkDefault false;
      };
    };
    group            = "users";
    openDefaultPorts = true;
  };
}
