_: {
  boot = {
    consoleLogLevel       = 0;
    initrd.systemd.enable = true;
    kernelParams          = [ "quiet" "udev.log_level=3" ];
    plymouth              = {
      enable      = true;
      extraConfig = "DeviceScale=2";
    };
  };
}
