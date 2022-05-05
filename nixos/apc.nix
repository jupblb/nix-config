_: {
  services.apcupsd = {
    configText = ''
      UPSCABLE usb
      UPSTYPE usb
      DEVICE
      BATTERYLEVEL 10
    '';
    enable     = true;
  };
}
